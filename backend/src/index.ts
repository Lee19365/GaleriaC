

import { pool } from './db';
import express from 'express';
import cors from 'cors';




const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'ArtNest API funcionando 🎨' });
});


app.get('/test-db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ conectado: true, hora_servidor: result.rows[0] });
  } catch (error) {
    console.error('Error al conectar con la base de datos:', error);
    res.status(500).json({ conectado: false, error: 'No se pudo conectar a la base de datos' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});