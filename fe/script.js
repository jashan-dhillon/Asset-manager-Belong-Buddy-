document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent form from submitting

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    // Simulate login process
    if (username === 'admin' && password === 'password') {
        alert('Logged in successfully!');
    } else {
        alert('Invalid username or password');
    }
});