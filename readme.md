# PROJECT APAYA

# Teknologi :
- backend LARAVEL 11
- WEBSERVER NGINX STABLE ALPHINE
- PHP 8.3 
- FLUTTER (MOBILE APPS)

# Data Endpoint : 
Main Endpoint : https://absen.djncloud.my.id

User :
```
Route::group(['prefix' => 'api/v1/account'], function() {
    Route::get('/', [UserController::class, 'index']);
    Route::get('/{id}', [UserController::class, 'get_user']);
    Route::post('/', [UserController::class, 'create']);
    Route::post('/login', [UserController::class, 'login']);
    Route::put('/{id}', [UserController::class, 'update']);
    Route::delete('/{id}', [UserController::class, 'delete']);
});
```

# HAPPY CODINGGGGG !!!!!!!!!!!!!!