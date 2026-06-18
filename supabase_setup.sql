-- ═══════════════════════════════════════════════════
-- Isuzu Sales Tracker — Supabase Setup
-- วิธีใช้: เปิด Supabase → SQL Editor → วาง run
-- ═══════════════════════════════════════════════════

-- 1. ตาราง settings (เซล / ทีม / dropdown)
create table if not exists settings (
  id uuid default gen_random_uuid() primary key,
  branch text not null,
  key text not null,       -- 'sales_list' | 'models' | 'careers'
  value jsonb not null,
  updated_at timestamptz default now()
);

-- 2. ตาราง entries (บันทึกรายวัน)
create table if not exists entries (
  id uuid default gen_random_uuid() primary key,
  branch text not null,
  sales_name text not null,
  team text,
  model text not null,     -- P-UP | MU-X
  entry_date date not null,
  lead int default 0,
  ps int default 0,
  bk int default 0,
  bk_car_model text,
  bk_career text,
  saved_by text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(branch, sales_name, model, entry_date)
);

-- 3. ตาราง promo_costs (ต้นทุนโปรโมท)
create table if not exists promo_costs (
  id uuid default gen_random_uuid() primary key,
  branch text not null,
  period_label text,
  date_start date not null,
  date_end date not null,
  cost_facebook numeric default 0,
  cost_google numeric default 0,
  cost_line numeric default 0,
  cost_event numeric default 0,
  created_at timestamptz default now()
);

-- 4. Enable Realtime
alter publication supabase_realtime add table entries;

-- 5. Row Level Security (ปิดไว้ก่อน — เปิดใช้เมื่อ deploy จริง)
-- alter table entries enable row level security;
-- alter table settings enable row level security;

-- 6. ข้อมูลตั้งต้น settings
insert into settings (branch, key, value) values
('บางเสาธง', 'sales_list', '[
  {"name":"ประยูร เครือญัญา","team":"ทีม A"},
  {"name":"สุดารัก เกศธิญัณน์","team":"ทีม A"},
  {"name":"สถิตย์ หอมเจือม","team":"ทีม B"}
]'),
('ศรีนครินทร์', 'sales_list', '[
  {"name":"วิชัย มีสุข","team":"ทีม A"},
  {"name":"นภา สุขสม","team":"ทีม B"}
]'),
('บางนา', 'sales_list', '[
  {"name":"พิมพ์ใจ แก้วมณี","team":"ทีม A"},
  {"name":"ธนา ศรีทอง","team":"ทีม B"}
]'),
('ALL', 'models', '["P-UP","MU-X","D-MAX 4WD","D-MAX 2WD","MU-X 4WD"]'),
('ALL', 'careers', '["เกษตรกร","รับราชการ","พนักงานบริษัท","ธุรกิจส่วนตัว","รับจ้างทั่วไป","ค้าขาย"]')
on conflict do nothing;
