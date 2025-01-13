<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class ForgotPasswordRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'email' => 'required|email|exists:users',
        ];
    }
    
    /**
     * Get the formatted data of the request.
     *
     * @return array
     */
    public function formattedData()
    {
        return [
            'email' => $this->input('email'),
            'code' => mt_rand(100000, 999999),
            'created_at' => now()
        ];
    }
}
