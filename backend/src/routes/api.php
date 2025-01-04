<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Auth\CodeCheckController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\Auth\ForgotPasswordController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

// Route::prefix('api/v1/account')->group(function () {
//     Route::post('/login', [AuthController::class, 'login']);
// });

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return response()->json([
//         'success' => true,
//         'data' => $request->user()
//     ]);
// });

 // Password reset routes
//  Route::post('password/email',  ForgotPasswordController::class);
//  Route::post('password/code/check', CodeCheckController::class);
//  Route::post('api/v1/password/reset', ResetPasswordController::class);