# Sattawat07 LazyVim Setup

ชุดตั้งค่า Neovim บน Ubuntu WSL ที่ใช้ LazyVim และ Mason พร้อมสำหรับเขียน C, C++, Python, Java, JavaScript, TypeScript, HTML, CSS, Tailwind CSS, PHP, Go, Bash, SQL, Markdown, Vue, Svelte และภาษาอื่น ๆ

## จุดเด่น

- ธีม TokyoNight Moon พร้อมพื้นหลังโปร่งใส
- ติดตั้ง LSP, formatter, linter และ debugger ผ่าน Mason
- กด `F5` เพื่อรันไฟล์เดี่ยวหลายภาษา
- บันทึกอัตโนมัติเมื่อออกจากโหมดพิมพ์หรือเปลี่ยนไฟล์
- กด `F1` เพื่อใส่หรืออัปเดต 42 Header
- ใช้ clipboard ร่วมกับ Windows ใน WSL
- เปิดไฟล์ HTML ในเบราว์เซอร์ด้วย `F5`
- ลดปัญหาค้างในไฟล์ HTML/JavaScript ด้วยการจำกัด LSP ให้เริ่มเฉพาะโปรเจกต์ที่เหมาะสม

## ติดตั้งบนเครื่องใหม่

เปิด Ubuntu/WSL แล้วรัน:

```bash
git clone https://github.com/Sattawat07/lazyvim-setup.git ~/.config/nvim
cd ~/.config/nvim
chmod +x install.sh
./install.sh
```

ตัวติดตั้งจะติดตั้งแพ็กเกจระบบ, Node.js, Neovim, Lazy plugins และเครื่องมือ Mason ที่จำเป็น หลังติดตั้งเสร็จให้เปิด shell ใหม่แล้วใช้:

```bash
nvim
```

## ปุ่มที่ใช้บ่อย

| ปุ่ม | การทำงาน |
| --- | --- |
| `F5` | รันไฟล์ปัจจุบัน |
| `F1` | ใส่หรืออัปเดต 42 Header |
| `Ctrl+/` | เปิดหรือปิด terminal |
| `Space e` | เปิด file explorer |
| `Space ff` | ค้นหาไฟล์ |
| `:Mason` | ดูและจัดการเครื่องมือภาษา |
| `:Lazy` | ดูและจัดการ plugin |

## ตั้งค่า 42 Header

ค่าเริ่มต้นอยู่ใน `lua/plugins/42header.lua`:

- Username: `sbontem`
- Email: `sboontem@student.42bangkok.com`

แก้สองค่านี้ให้ตรงกับบัญชีของคุณก่อนใช้งานบนเครื่องอื่น

## ภาพพื้นหลัง

ภาพพระจันทร์ที่ใช้กับ Windows Terminal อยู่ใน `assets/moonlit-lake.png` ให้นำไปตั้งเป็น background image ของ Windows Terminal และปรับ opacity ตามต้องการ

## อัปเดตในอนาคต

```bash
cd ~/.config/nvim
git pull
nvim --headless "+Lazy! sync" +qa
```

ชุดนี้ออกแบบสำหรับ Ubuntu บน WSL การใช้บน Linux ปกติทำได้เกือบทั้งหมด แต่ส่วน clipboard และการเปิด HTML จะทำงานต่างออกไปตามระบบ
