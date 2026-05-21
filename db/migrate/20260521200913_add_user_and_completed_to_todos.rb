class AddUserAndCompletedToTodos < ActiveRecord::Migration[8.1]
  def up
    add_reference :todos, :user, foreign_key: true
    add_column :todos, :completed, :boolean, default: false, null: false

    legacy_user_id = insert_legacy_user
    execute <<~SQL.squish
      UPDATE todos SET user_id = #{legacy_user_id} WHERE user_id IS NULL
    SQL

    change_column_null :todos, :user_id, false
  end

  def down
    remove_reference :todos, :user, foreign_key: true
    remove_column :todos, :completed
    execute "DELETE FROM users WHERE email = 'legacy@example.com'"
  end

  private

  def insert_legacy_user
    password_digest = BCrypt::Password.create("password")
    now = connection.quote(Time.current)
    execute <<~SQL.squish
      INSERT INTO users (email, password_digest, created_at, updated_at)
      VALUES ('legacy@example.com', #{connection.quote(password_digest)}, #{now}, #{now})
    SQL
    select_value("SELECT id FROM users WHERE email = 'legacy@example.com'").to_i
  end
end
