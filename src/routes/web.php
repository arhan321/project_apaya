<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DataKelasController;
use App\Http\Controllers\Auth\CodeCheckController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\Auth\ForgotPasswordController;

//route default
Route::get('/', function () {
    return view('welcome');
});
// Password reset routes
Route::post('password/email', ForgotPasswordController::class);
Route::post('password/code/check', CodeCheckController::class);
Route::post('password/reset', [ResetPasswordController::class, '__invoke']);
Route::get('/resetdata', [ForgotPasswordController::class, 'index']);

// api account
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

//api data kelas 
Route::group(['prefix' => 'api/v1/kelas'], function () {
    Route::get('/', [DataKelasController::class, 'index']); 
    Route::get('/{id}', [DataKelasController::class, 'show']); 
    Route::post('/data-kelas', [DataKelasController::class, 'store']); 
    Route::put('/{id}', [DataKelasController::class, 'update']); 
    Route::put('/update/{id}', [DataKelasController::class, 'update']); 
    Route::delete('/{id}', [DataKelasController::class, 'destroy']);
    Route::delete('/delete/{id}', [DataKelasController::class, 'deleteSiswa']);
});

