export default async function handler(req, res) {
    // 1. THAY ĐỔI CÁC THÔNG TIN DƯỚI ĐÂY CHO ĐÚNG VỚI BẠN:
    const USERNAME = 'yuitohime'; 
    const REPO = 'scriptjoodri';   
    const FILENAME = 'main.lua'; // Tên file script Lua gốc của bạn nằm trong kho Private
    
    // 2. PHẦN CODE HỆ THỐNG (GIỮ NGUYÊN KHÔNG SỬA):
    const TOKEN = process.env.GITHUB_TOKEN; 
    const url = `https://raw.githubusercontent.com/${USERNAME}/${REPO}/main/${FILENAME}`;

    try {
        const response = await fetch(url, {
            headers: { 'Authorization': `token ${TOKEN}` }
        });

        if (!response.ok) {
            return res.status(404).send('Không tìm thấy file Lua trong kho Private!');
        }

        const script = await response.text();
        
        // Cấu hình trả về dưới dạng văn bản thô (Text) để loadstring đọc được
        res.setHeader('Content-Type', 'text/plain');
        res.status(200).send(script);
    } catch (error) {
        res.status(500).send('Lỗi Server Trung Gian!');
    }
}
