Link to your GitHub Classroom hw5 repository / branch
    - https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/tree/hw5

Link to .cursorignore
    - https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/blob/hw5/.cursorignore

Links to AGENTS.md , .cursor/rules/rails-conventions.mdc , and .cursor/rules/security.mdc
    - AGENT.md link: https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/blob/hw5/AGENTS.md
    - rails-conventions.mdc link: https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/blob/hw5/.cursor/rules/rails-conventions.mdc
    - security.mdc: https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/blob/hw5/.cursor/rules/security.mdc

Part 3 responses in this document: 
    - Ask-mode prompt/results: 
        - Where in this codebase is "create new todos" currently implemented? Cite the exact files and line numbers. Do not propose changes
        - config/routes.rb L1-2
        - app/controllers/todos_controller.rb L13-16, 22-35, 73-76
        - app/views/todos/index.html.erb L16-16
        - app/views/todos/new.html.erb L1-5
        - app.views/todos/_form.html.erb L1-22
        - app/models/todo.rb L1-2
        - db/migrate/20260519180909_create_todos.rb L3-7
        - db/schema.rb L14-19
        - test/controllers/todos_controller_test.rb L18-24
        - test/system/todos_tst.rb L13-21
    - Plan-mode result + your edits: 
        - Add minimal user authentication, associate todos with their creator on create, add a completed flag with a dedicated mark-done action, and enforce that only the owning user can mark a todo done—following AGENTS.md patterns (current_user, strong params, no new gems).
        - Uncomment bcrypt in Gemfile and bundle install
        - Add create_users and add user_id/completed to todos migrations
        - User model, Sessions/Users controllers, current_user and require_login in ApplicationController
        - Assign creator on create via current_user.todos.build; require login
        - mark_done route/action, authorize_todo_owner!, conditional UI in todo partials
        - Update fixtures/seeds; add controller/system tests and log_in_as helper

    - Agent-mode prompt + commit link:
        - Implement just the user model
        - Link: https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/commit/fdd62d58fc765ff6b7c2eb702b1b5390bc147042

    - Bad -> good prompt rewrite:
        - Bad: "fix the bug in todos"
        - Good: "1. Context
                Model: app/models/todo.rb — belongs_to :user, validates :user, presence: true
                Controller: app/controllers/todos_controller.rb — new / create still use Todo.new(todo_params) (lines 14–24)
                Schema: db/schema.rb — todos.user_id is null: false with a foreign key to users
                Auth helpers (present but unused for create): app/controllers/application_controller.rb — current_user, require_login
                Tests: test/controllers/todos_controller_test.rb (test "should create todo"), fixtures test/fixtures/todos.yml (no user association yet)
                2. Task
                Wire todo create to the logged-in user: require login for new and create, build todos with current_user.todos.build(todo_params), and keep strong params limited to :description (do not permit :user_id or :completed).

                3. Expected vs. actual
                Expected: After signing in, visiting /todos/new, submitting a description, and clicking Create Todo redirects to the show page with “Todo was successfully created.” Todo.last.user_id equals the signed-in user’s id.

                Actual: POST /todos re-renders the new form with validation errors (or fails to save) because no user is assigned. The controller still does:

                @todo = Todo.new(todo_params)
                while the model requires user. Running the suite shows the failure in:

                test/controllers/todos_controller_test.rb:18
                test "should create todo"
                # assert_difference("Todo.count") fails — count does not change
                Fixtures may also fail to load until test/fixtures/users.yml exists and todos.yml references user: one.

                4. Constraints
                May edit: app/controllers/todos_controller.rb, app/controllers/application_controller.rb (only if needed for require_login), test/controllers/todos_controller_test.rb, test/test_helper.rb, test/fixtures/todos.yml, new test/fixtures/users.yml
                Do not add gems (use existing bcrypt / has_secure_password; no Devise)
                Follow: current_user + require_login in controllers; strong params via params.expect; redirect/render with :unprocessable_entity on validation failure per project conventions
                Out of scope for this task: mark_done, signup/login UI, or restricting edit/destroy to the creator
                5. Done when
                bundle exec rails test test/controllers/todos_controller_test.rb passes, including an updated "should create todo" that logs in a fixture user first and asserts Todo.last.user_id == users(:one).id
                Unauthenticated post todos_url redirects to new_session_path
                Manual check: log in → New todo → submit → todo appears on index/show and belongs to the current user"

Part 4 Turbo Streams explanation in this document, including what you verified against the Turbo Streams handbook or Rails source
    - Turbo Stream is a small response that tells the browser how to change parts of the current page without loading a full new html document.
    - Verified that stream actions match my target DOM ids.

Part 4 pull request URL, with PR description containing Story, Plan, Tests, and Things I rejected from the AI
    - https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-rhit-shaoz3/pull/1