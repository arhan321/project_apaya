<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Http\Request;
use App\Models\ResetCodePassword;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use App\Mail\SendCodeResetPassword;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Mail;
use App\Http\Requests\Auth\ForgotPasswordRequest;

class ForgotPasswordController extends Controller
{
    /**
     * Retrieve all reset code records (for debugging purposes).
     *
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        // Periksa apakah permintaan berasal dari browser
        $userAgent = $request->headers->get('User-Agent');
        if ($userAgent && preg_match('/Mozilla|Chrome|Safari/', $userAgent)) {
            return abort(404); // Balikan 404 jika berasal dari browser
        }
    
        // Ambil data dari database
        $query = DB::connection('mysql')->table('reset_code_passwords')->get();
    
        // Log data yang diambil
        Log::info('Retrieved all reset codes from the database', ['records' => $query]);
    
        // Kembalikan data dalam format JSON
        return response()->json($query, 200);
    }
    

    /**
     * Handle the incoming request to send reset code via email.
     *
     * @param ForgotPasswordRequest $request
     * @return JsonResponse
     */
    public function __invoke(ForgotPasswordRequest $request): JsonResponse
    {
        // Log request received
        Log::info('Password reset request received', ['email' => $request->email]);

        try {
            // Hapus kode reset password lama untuk email ini
            ResetCodePassword::where('email', $request->email)->delete();
            Log::info('Old reset codes deleted for email', ['email' => $request->email]);

            // Buat kode reset password baru
            $codeData = ResetCodePassword::create([
                'email' => $request->email,
                'code' => $this->generateResetCode(),
                'created_at' => now(),
            ]);
            Log::info('New reset code created', [
                'email' => $codeData->email,
                'code' => $codeData->code,
            ]);

            // Kirim email dengan kode reset password
            Mail::to($request->email)->send(new SendCodeResetPassword($codeData->code));
            Log::info('Reset code email sent', ['email' => $request->email]);

            // Kembalikan respon JSON
            return response()->json([
                'message' => trans('passwords.sent'),
                'status' => 200,
            ], 200);

        } catch (\Exception $e) {
            // Log error
            Log::error('Error occurred during password reset process', [
                'email' => $request->email,
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'message' => 'An error occurred while processing your request',
                'status' => 500,
            ], 500);
        }
    }

    /**
     * Generate a random reset code.
     *
     * @return int
     */
    private function generateResetCode(): int
    {
        $code = rand(100000, 999999); // Kode 6 digit acak
        Log::info('Generated reset code', ['code' => $code]);
        return $code;
    }
}
