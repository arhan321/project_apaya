<?php


use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

//route default
Route::get('/', function () {
    return view('welcome');
});

// api absen
Route::group(['prefix' => 'api/v1/account'], function () {
    Route::get('/', [AuthController::class, 'index']);
    Route::get('/{id}', [AuthController::class, 'get_user']);
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    // Route::post('/logout', [AuthController::class, 'logout']);
    Route::put('/{id}', [AuthController::class, 'update']);
    Route::delete('/{id}', [AuthController::class, 'delete']);
});

Route::post('/auth/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/auth/me', [AuthController::class, 'getLoggedInUser'])->middleware('auth:sanctum');

