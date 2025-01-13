@component('mail::message')
<h1>Absenku Reset Password</h1>
<h2>We have received your request to reset your account password</h2>
<p>You can use the following code to recover your account (OTP):</p>

@component('mail::panel')
{{ $code }}
@endcomponent

<p>The allowed duration of the code is one hour from the time the message was sent</p>
@endcomponent
