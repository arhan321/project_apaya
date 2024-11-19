<?php

use App\Http\Controllers\Frontend;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\DataDosenController;

//route default
Route::get('/', function () {
    return view('welcome');
});

// Halaman Login
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login']);

// Reset Password
Route::get('/password/reset', [AuthController::class, 'showResetPasswordForm'])->name('password.request');
Route::post('/password/email', [AuthController::class, 'sendResetPasswordLink'])->name('password.email');

// Menangani reset password dengan token (password.reset)
Route::get('/password/reset/{token}', [AuthController::class, 'showResetForm'])->name('password.reset');
Route::post('/password/reset', [AuthController::class, 'resetPassword'])->name('password.update');

// Halaman setelah login berhasil
Route::get('/home', [Frontend::class, 'home']);

//route api
Route::group(['prefix' => 'api/v1/account'], function() {
    Route::get('/', [UserController::class, 'index']);
    Route::get('/{id}', [UserController::class, 'get_user']);
    Route::post('/', [UserController::class, 'create']);
    Route::post('/login', [UserController::class, 'login']);
    Route::put('/{id}', [UserController::class, 'update']);
    Route::delete('/{id}', [UserController::class, 'delete']);
});

Route::group(['prefix' => 'api/v1/dosen'], function() {
    Route::get('/', [DataDosenController::class, 'index']);
    Route::get('/{id}', [DataDosenController::class, 'get_dosen']);
    Route::post('/', [DataDosenController::class, 'create']);
    Route::put('/{id}', [DataDosenController::class, 'update']);
    Route::delete('/{id}', [DataDosenController::class, 'delete']);
});
