<?php

namespace App\Http\Controllers\Auth;

use App\Models\ResetCodePassword;
use Illuminate\Http\JsonResponse;
use App\Mail\SendCodeResetPassword;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Mail;
use App\Http\Requests\Auth\ForgotPasswordRequest;

class ForgotPasswordController extends Controller
{
    /**
     * Handle the incoming request to send reset code via email.
     *
     * @param  ForgotPasswordRequest $request
     * @return JsonResponse
     */
    public function __invoke(ForgotPasswordRequest $request): JsonResponse
    {
        // Hapus kode reset password lama untuk email ini
        ResetCodePassword::where('email', $request->email)->delete();

        // Buat kode reset password baru
        $codeData = ResetCodePassword::create([
            'email' => $request->email,
            'code' => $this->generateResetCode(),
            'created_at' => now(),
        ]);

        // Kirim email dengan kode reset password
        Mail::to($request->email)->send(new SendCodeResetPassword($codeData->code));

        // Kembalikan respon JSON
        return response()->json([
            'message' => trans('passwords.sent'),
            'status' => 200,
        ], 200);
    }

    /**
     * Generate a random reset code.
     *
     * @return int
     */
    private function generateResetCode(): int
    {
        return rand(100000, 999999); // Kode 6 digit acak
    }
}
