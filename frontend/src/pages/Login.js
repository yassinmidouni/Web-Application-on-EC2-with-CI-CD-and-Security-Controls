import React, { useState } from 'react';
import { login } from '../services/api';

const Login = () => {
    const [formData, setFormData] = useState({ username: '', password: '' });
    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const { data } = await login(formData);
            localStorage.setItem('token', data.token);
            alert('Login successful');
        } catch (err) {
            alert('Login failed');
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <input 
                type="text" 
                placeholder="Username" 
                onChange={(e) => setFormData({ ...formData, username: e.target.value })} 
            />
            <input 
                type="password" 
                placeholder="Password" 
                onChange={(e) => setFormData({ ...formData, password: e.target.value })} 
            />
            <button type="submit">Login</button>
        </form>
    );
};

export default Login;
