## LARAVEL API

1.  Create Laravel application
    
    `laravel new api-advertisement`
    
    OR
    
    `composer create-project laravel/laravel api-advertisement`
    
2.  Update the create\_users\_table migration
    
    Add `$table->boolean('is_admin')->default(false);` to the code
    
    The database/migrations/0001\_01\_01\_000000\_create\_users\_table.php file content will become
    
    ```php
    <?php
    
    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;
    
    return new class extends Migration
    {
        /**
         * Run the migrations.
         */
        public function up(): void
        {
            Schema::create('users', function (Blueprint $table) {
                $table->id();
                $table->string('name');
                $table->string('email')->unique();
                $table->timestamp('email_verified_at')->nullable();
                $table->string('password');
                $table->boolean('is_admin')->default(false);
                $table->rememberToken();
                $table->timestamps();
            });
    
            Schema::create('password_reset_tokens', function (Blueprint $table) {
                $table->string('email')->primary();
                $table->string('token');
                $table->timestamp('created_at')->nullable();
            });
    
            Schema::create('sessions', function (Blueprint $table) {
                $table->string('id')->primary();
                $table->foreignId('user_id')->nullable()->index();
                $table->string('ip_address', 45)->nullable();
                $table->text('user_agent')->nullable();
                $table->longText('payload');
                $table->integer('last_activity')->index();
            });
        }
    
        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('users');
            Schema::dropIfExists('password_reset_tokens');
            Schema::dropIfExists('sessions');
        }
    };
    ```
    
3.  Create Two users
    
    In the `database/seeders/DatabaseSeeder.php` add the following code
    ```php
            User::factory()->create([
                'name' => 'Super User',
                'email' => 'admin@example.com',
                'password' => bcrypt('password'),
                'is_admin' => true,
            ]);
            User::factory()->create([
                'name' => 'Another User',
                'email' => 'another@example.com',
                'password' => bcrypt('password'),
            ]);
    ```
    
    The entire code will become
    
    `database/seeders/DatabaseSeeder.php`
    ```php
    <?php
    
    namespace Database\Seeders;
    
    use App\Models\Advertisement;
    use App\Models\User;
    // use Illuminate\Database\Console\Seeds\WithoutModelEvents;
    use Illuminate\Database\Seeder;
    
    class DatabaseSeeder extends Seeder
    {
        /**
         * Seed the application's database.
         */
        public function run(): void
        {
            // User::factory(10)->create();
    
            User::factory()->create([
                'name' => 'Super User',
                'email' => 'admin@example.com',
                'password' => bcrypt('password'),
                'is_admin' => true,
            ]);
            User::factory()->create([
                'name' => 'Another User',
                'email' => 'another@example.com',
                'password' => bcrypt('password'),
            ]);
    
        }
    }
    ```
    
4.  Make Advertisement Model, Migration for the model and Controller with resource methods for the model
    
    `Terminal`
    
    ```plaintext
    php artisan make:model Advertisement -mcr
    ```
    
5.  Update the migration file to define the structure of our advertisement
    
    Add the following code in
    
    `database/migrations/timestamp_create_advertisements_table.php`
    
    ```php
    $table->string('title');
    $table->string('content');
    $table->string('image_path')->nullable();
    $table->boolean('is_approved')->default(false);
    $table->foreignIdFor(User::class);
    ```
    
    *   You need to add
        
        ```php
        use App\Models\User;
        ```
        
        On the top of the page
        
    
    **The full code will looks like**
    
    `database/migrations/timestamp_create_advertisements_table.php`
    
    ```php
    <?php
    
    use App\Models\User;
    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;
    
    return new class extends Migration
    {
        /**
         * Run the migrations.
         */
        public function up(): void
        {
            Schema::create('advertisements', function (Blueprint $table) {
                $table->id();
                $table->string('title');
                $table->string('content');
                $table->string('image_path')->nullable();
                $table->boolean('is_approved')->default(false);
                $table->foreignIdFor(User::class)->nullable();
                $table->timestamps();
            });
        }
    
        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('advertisements');
        }
    };
    ```
    
6.  Run the migration  
    `Terminal`
    
    ```php
    php artisan migrate
    ```
    
    Note:
    
    _user\_id column will be created by_ `$table->foreignIdFor(User::class);`
    
7.  Add another seeder to create a dummy advertisement data  
    `database/seeders/DatabaseSeeder.php`
8.  ```php
    
    Advertisement::create([
        'title' => 'Virthli',
        'content' => 'MZU will be organizing Virthli, everyone is invited to come. Ticket will be available by the main gate',
        'is_approved' => true,
        'user_id' => 1
    ]);
    
    Advertisement::create([
        'title' => 'Software Engineer Job Vacant',
        'content' => 'A full-stack software engineer job vacnt in Microsoft mizoram branch',
        'is_approved' => true,
        'user_id' => 2
    ]);
    
    Advertisement::create([
        'title' => 'Programming Course',
        'content' => 'A full-stack programming 6 months course is open contact 123456789 for detail',
        'is_approved' => false,
        'user_id' => 2
    ]);
    ```
    
    Wih the existing one. The entire DatabaseSeeder.php file will look like
    
9.  ```php
    <?php
    
    namespace Database\Seeders;
    
    use App\Models\Advertisement;
    use App\Models\User;
    // use Illuminate\Database\Console\Seeds\WithoutModelEvents;
    use Illuminate\Database\Seeder;
    
    class DatabaseSeeder extends Seeder
    {
        /**
         * Seed the application's database.
         */
        public function run(): void
        {
            // User::factory(10)->create();
    
            User::factory()->create([
                'name' => 'Super User',
                'email' => 'admin@example.com',
                'password' => bcrypt('password'),
                'is_admin' => true,
            ]);
            User::factory()->create([
                'name' => 'Another User',
                'email' => 'another@example.com',
                'password' => bcrypt('password'),
            ]);
    
            Advertisement::create([
                'title' => 'Virthli',
                'content' => 'MZU will be organizing Virthli, everyone is invited to come. Ticket will be available by the main gate',
                'is_approved' => true,
                'user_id' => 1
            ]);
    
            Advertisement::create([
                'title' => 'Software Engineer Job Vacant',
                'content' => 'A full-stack software engineer job vacnt in Microsoft mizoram branch',
                'is_approved' => true,
                'user_id' => 2
            ]);
    
            Advertisement::create([
                'title' => 'Programming Course',
                'content' => 'A full-stack programming 6 months course is open contact 123456789 for detail',
                'is_approved' => false,
                'user_id' => 2
            ]);
        }
    }
    ```
    
10.  Run the seeder  
    `Terminal`
    
    ```plaintext
    php artisan db:seed
    ```
    
    This will create admin user, another user and the three advertisement entries.
    
11.  Add a method to fetch the advertisements
    
    In `app/Http/Controllers/AdvertisementController.php` update the index() method
    
    ```php
    public function index()
    {
        return Advertisement::all();
    }
    ```
    
12.  Generate api route  
    `Terminal`
    
    ```plaintext
    php artisan install:api
    ```
    
    Run the migration.
    
13.  Create a route to fetch the advertisements  
    in the `routes/api.php` file, Add
    
    ```php
    Route::apiResource('/', function () {
        return view('welcome');
    });
    ```
    
    This will create all the required endpoints to utilize/access the api resource methods.
    
14.  Then, you will be able to access the dummy data from the web page
    
    Click [HERE](http://127.0.0.1:8000/api/advertisements) to view the data returned by the api
    
15.  Add a method to store the advertisements
    
	    In `app/Http/Controllers/AdvertisementController.php` update the store() method
	    
	    ```php
	    public function store(Request $request)
	    {
	        $validated = $request->validate([
	            'title' => 'required',
	            'content' => 'required',
	            'is_approved' => 'nullable',
	        ]);
	    
	        $validated['user_id'] = request()?->user()?->id ?? null;
	    
	        Advertisement::create($validated);
	        return $this->index();
	    }
    	```
    
    Note:
    
    the Route::apiResource('advertisements') method called in `routes/api.php` already defined the route for this store and all other required methods for api Advertisement routes.
    
16.  Add a method to store the advertisements
17.  In `app/Http/Controllers/AdvertisementController.php` update the update() method
    
	    ```php
	    public function update(Request $request, Advertisement $advertisement)
	    {
	        $validated = $request->validate([
	            'title' => 'required',
	            'content' => 'required',
	            'is_approved' => 'nullable',
	        ]);
	    
	        $advertisement->update($validated);
	        return $this->index();
	    }
	    ```
    
18.  In `app/Http/Controllers/AdvertisementController.php` update the destroy() method
    
	    ```php
	    public function update(Advertisement $advertisement)
	    {
	        $advertisement->delete();
	        return $this->index();
	    }
	    ```
    
19.  Now the entire AdvertisementController.php file will have the following content
    
	    ```php
	    <?php
	    
	    namespace App\Http\Controllers;
	    
	    use App\Models\Advertisement;
	    use Illuminate\Http\Request;
	    
	    class AdvertisementController extends Controller
	    {
	        /**
	         * Display a listing of the resource.
	         */
	        public function index()
	        {
	            return Advertisement::all();
	        }
	    
	        /**
	         * Show the form for creating a new resource.
	         */
	        public function create()
	        {
	            //
	        }
	    
	        /**
	         * Store a newly created resource in storage.
	         */
	        public function store(Request $request)
	        {
	            $validated = $request->validate([
	                'title' => 'required',
	                'content' => 'required',
	                'is_approved' => 'nullable',
	            ]);
	    
	            $validated['user_id'] = request()?->user()->id ?? null;
	    
	            Advertisement::create($validated);
	            return $this->index();
	        }
	    
	        /**
	         * Display the specified resource.
	         */
	        public function show(Advertisement $advertisement)
	        {
	            //
	        }
	    
	        /**
	         * Show the form for editing the specified resource.
	         */
	        public function edit(Advertisement $advertisement)
	        {
	            //
	        }
	    
	        /**
	         * Update the specified resource in storage.
	         */
	        public function update(Request $request, Advertisement $advertisement)
	        {
	            $validated = $request->validate([
	                'title' => 'required',
	                'content' => 'required',
	                'is_approved' => 'nullable',
	            ]);
	    
	            $advertisement->update($validated);
	            return $this->index();
	        }
	    
	        /**
	         * Remove the specified resource from storage.
	         */
	        public function destroy(Advertisement $advertisement)
	        {
	            $advertisement->delete();
	            return $this->index();
	        }
	    }
	    ```
