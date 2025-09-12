import React, { useState } from 'react';

function App() {
  const [osInfo, setOsInfo] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleGetOsInfo = async () => {
    setLoading(true);
    setError('');
    setOsInfo('');

    try {
      const response = await fetch('/api/os-info');
      const data = await response.json();

      if (data.success) {
        setOsInfo(data.osInfo);
      } else {
        setError(data.error || 'Failed to fetch OS information');
      }
    } catch (err) {
      setError('Network error: Unable to connect to backend server');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ 
      textAlign: 'center', 
      padding: '20px', 
      fontFamily: 'Arial, sans-serif',
      maxWidth: '800px',
      margin: '0 auto'
    }}>
      <header>
        <h1>OS Information Reader</h1>
        <p>Click the button below to fetch operating system information from the server.</p>
        
        <button 
          onClick={handleGetOsInfo}
          disabled={loading}
          style={{
            padding: '12px 24px',
            fontSize: '16px',
            backgroundColor: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: loading ? 'not-allowed' : 'pointer',
            opacity: loading ? 0.6 : 1,
            marginBottom: '20px'
          }}
        >
          {loading ? 'Loading...' : 'Get OS Info'}
        </button>

        {error && (
          <div style={{
            color: '#dc3545',
            backgroundColor: '#f8d7da',
            border: '1px solid #f5c6cb',
            borderRadius: '4px',
            padding: '12px',
            margin: '10px 0'
          }}>
            <strong>Error:</strong> {error}
          </div>
        )}

        {osInfo && (
          <div style={{
            backgroundColor: '#f8f9fa',
            border: '1px solid #dee2e6',
            borderRadius: '4px',
            padding: '15px',
            margin: '10px 0',
            textAlign: 'left'
          }}>
            <h3>OS Release Information:</h3>
            <pre style={{
              whiteSpace: 'pre-wrap',
              fontFamily: 'monospace',
              fontSize: '14px',
              margin: 0
            }}>
              {osInfo}
            </pre>
          </div>
        )}
      </header>
    </div>
  );
}

export default App;
