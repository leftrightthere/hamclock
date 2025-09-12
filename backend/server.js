const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;

// Enable CORS for frontend requests
app.use(cors());
app.use(express.json());

// Serve React app static files
const reactAppPath = process.env.NODE_ENV === 'production' ? '/opt/react-app' : path.join(__dirname, '../react-app/build');
app.use(express.static(reactAppPath));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Backend server is running' });
});

// Secure endpoint to get OS information
app.get('/api/os-info', (req, res) => {
  // Use absolute path to the shell script to prevent path traversal
  const scriptPath = path.join(__dirname, 'get-os-info.sh');
  
  // Execute the shell script with no user input to prevent command injection
  exec(scriptPath, { timeout: 5000 }, (error, stdout, stderr) => {
    if (error) {
      console.error('Error executing script:', error);
      return res.status(500).json({ 
        error: 'Failed to retrieve OS information',
        details: error.message 
      });
    }
    
    if (stderr) {
      console.error('Script stderr:', stderr);
      return res.status(500).json({ 
        error: 'Script execution warning',
        details: stderr 
      });
    }
    
    // Return the OS release information
    res.json({ 
      success: true, 
      osInfo: stdout.trim(),
      timestamp: new Date().toISOString()
    });
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend server running on port ${PORT}`);
  console.log(`Serving React app at http://localhost:${PORT}`);
});