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
// api absen
Route::group(['prefix' => 'api/v1/account'], function () {
    Route::get('/', [AuthController::class, 'index']);
    Route::get('/{id}', [AuthController::class, 'get_user']);
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    // Route::post('/logout', [AuthController::class, 'logout']);
    Route::put('/{id}', [AuthController::class, 'update']);
    Route::post('/{id}/foto', [AuthController::class, 'uploadPhoto']);
    Route::delete('/{id}', [AuthController::class, 'delete']);
});
Route::post('/auth/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/auth/me', [AuthController::class, 'getLoggedInUser'])->middleware('auth:sanctum');

```

# HAPPY CODINGGGGG !!!!!!!!!!!!!!