import express, { Request, Response } from 'express';
import cors from 'cors';
import crypto from 'crypto';

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json({ limit: '10mb' }));

interface ProcessRequest {
  document_text: string;
}

interface ProcessResponse {
  status: 'success' | 'error';
  complexity_score: 'simple' | 'complex';
  document_hash: string;
  processed_by: string;
  processing_time_ms: number;
}

function processDocument(text: string): Omit<ProcessResponse, 'processing_time_ms'> {
  const words = text.trim().split(/\s+/).filter(word => word.length > 0);
  const wordCount = words.length;
  
  const complexity_score = wordCount > 50 ? 'complex' : 'simple';
  
  const hash = crypto.createHash('sha256');
  hash.update(text);
  const document_hash = hash.digest('hex');
  
  return {
    status: 'success',
    complexity_score,
    document_hash,
    processed_by: 'TypeScript API'
  };
}

app.post('/process', (req: Request<{}, {}, ProcessRequest>, res: Response<ProcessResponse>) => {
  const startTime = performance.now();
  
  try {
    const { document_text } = req.body;
    
    if (!document_text || typeof document_text !== 'string') {
      res.status(400).json({
        status: 'error',
        complexity_score: 'simple',
        document_hash: '',
        processed_by: 'TypeScript API',
        processing_time_ms: performance.now() - startTime
      });
      return;
    }
    
    const result = processDocument(document_text);
    const processing_time_ms = performance.now() - startTime;
    
    res.json({
      ...result,
      processing_time_ms
    });
  } catch (error) {
    const processing_time_ms = performance.now() - startTime;
    res.status(500).json({
      status: 'error',
      complexity_score: 'simple',
      document_hash: '',
      processed_by: 'TypeScript API',
      processing_time_ms
    });
  }
});

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'healthy', api: 'TypeScript' });
});

app.listen(PORT, () => {
  console.log(`TypeScript API listening on port ${PORT}`);
});