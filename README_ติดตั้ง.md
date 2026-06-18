# Isuzu Sales Tracker — วิธีติดตั้ง (Supabase)

## ไฟล์ที่ได้รับ
| ไฟล์ | ใช้สำหรับ |
|------|----------|
| `branch.html` | หน้าเซลกรอกข้อมูล (ทุกสาขาใช้ไฟล์เดียวกัน ต่างกันแค่ URL) |
| `admin.html` | หน้า Admin / การตลาด เห็นทุกสาขา |
| `supabase_setup.sql` | SQL สร้าง database |
| `README.md` | ไฟล์นี้ |

---

## ขั้นตอนที่ 1 — สร้าง Supabase Project

1. ไปที่ https://supabase.com → Sign up ฟรี
2. กด **New project** → ตั้งชื่อ เช่น `isuzu-sales`
3. รอ 1-2 นาที ให้ project พร้อม

---

## ขั้นตอนที่ 2 — สร้าง Database

1. เปิด Supabase project → เมนูซ้าย **SQL Editor**
2. กด **New query**
3. วาง code ทั้งหมดจากไฟล์ `supabase_setup.sql`
4. กด **Run** (หรือ Ctrl+Enter)
5. ควรเห็น "Success" ทุก statement

---

## ขั้นตอนที่ 3 — หา Supabase URL และ Key

1. เมนูซ้าย **Project Settings** → **API**
2. Copy:
   - **Project URL** → `https://xxxx.supabase.co`
   - **anon / public key** → `eyJhbGciOiJ...` (อย่าใช้ service_role!)

---

## ขั้นตอนที่ 4 — Upload ไฟล์ขึ้น Netlify (ฟรี)

### วิธีง่ายที่สุด — Netlify Drop
1. ไปที่ https://app.netlify.com/drop
2. ลาก folder ที่มีไฟล์ทั้งหมดไปวาง
3. รอ 30 วินาที → ได้ link เช่น `https://amazing-name-123.netlify.app`

### หรือ GitHub Pages
1. สร้าง repo ใน GitHub
2. อัปโหลดไฟล์ → Settings → Pages → Deploy from main

---

## ขั้นตอนที่ 5 — ตั้งค่าครั้งแรก

### สำหรับ Admin
1. เปิด `admin.html`
2. ใส่ Supabase URL + Key ในช่อง config
3. ใส่รหัสผ่าน: **admin1234** (เปลี่ยนได้ในโค้ด)
4. กด **เข้าสู่ระบบ Admin**
5. ไปหน้า **ตั้งค่า** → เพิ่มรายชื่อเซล ทีม รุ่นรถ อาชีพ

### สำหรับเซล
เปิด `branch.html` ครั้งแรก → ใส่ Supabase URL + Key → กด **บันทึกและเชื่อมต่อ**
(จำค่าไว้ใน localStorage ไม่ต้องใส่ซ้ำ)

---

## Links แยกสาขา

```
https://your-site.netlify.app/branch.html?branch=บางเสาธง
https://your-site.netlify.app/branch.html?branch=ศรีนครินทร์
https://your-site.netlify.app/branch.html?branch=บางนา
https://your-site.netlify.app/admin.html
```

**วิธีส่งให้เซล:** ส่ง link ของสาขาตัวเองให้แต่ละสาขา
- แต่ละสาขาเข้าได้เลย ไม่ต้อง login
- เซลสาขาบางเสาธงเปิด link บางเสาธง → เห็นเฉพาะเซลของตัวเอง
- ไม่มีทางข้ามไปดูสาขาอื่นได้

---

## รหัสผ่าน (เปลี่ยนได้ในโค้ด admin.html)

```javascript
var ADMIN_PASSWORD = 'admin1234';
```

---

## Features

### branch.html (เซล)
- ✅ Tab วันที่ — เลือกย้อนหลังได้ สีแสดงสถานะ (กรอกแล้ว/ยังไม่กรอก)
- ✅ Heatmap รายเซล — เห็นทันทีว่าวันไหนไม่ได้คีย์
- ✅ กรอก Lead/PS/BK แยก P-UP / MU-X
- ✅ เมื่อ BK > 0 → เด้ง dropdown รุ่นรถ + อาชีพ
- ✅ บันทึกลง Supabase realtime
- ✅ ออฟไลน์ได้ → queue ส่งเมื่อกลับมาออนไลน์

### admin.html (การตลาด)
- ✅ Login ด้วย password ครั้งเดียว
- ✅ Tab แยก: ภาพรวมทุกสาขา / บางเสาธง / ศรีนครินทร์ / บางนา
- ✅ Metric cards: Lead, PS, BK, Conversion Rate
- ✅ กราฟรายวันแต่ละสาขา
- ✅ Conversion Rate + อัตราส่วน (Lead→PS, PS→BK, Lead→BK)
- ✅ Heatmap รายสาขา + รายเซล
- ✅ แจ้งเตือนเซลที่ยังไม่กรอกวันนี้
- ✅ Realtime — อัปเดตอัตโนมัติเมื่อเซลกรอก
- ✅ ต้นทุน: กำหนดช่วงเวลาได้เอง (1-6 ช่วง) คำนวณต้นทุน/Lead-PS-BK ต่อช่วง
- ✅ ตั้งค่า: เพิ่ม/ลบเซล ทีม รุ่นรถ อาชีพ → บันทึกลง Supabase

---

## Supabase Tables

| Table | ใช้สำหรับ |
|-------|----------|
| `entries` | บันทึก Lead/PS/BK รายวัน |
| `settings` | รายชื่อเซล ทีม รุ่นรถ อาชีพ |
| `promo_costs` | ค่าโปรโมท (optional) |
