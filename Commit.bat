@echo off
set /p msg="Nhap noi dung commit (Nhan Enter de dung mac dinh: Update Portfolio): "

if "%msg%"=="" set msg=Update Portfolio

echo ------------------------------------------
echo [+] Dang chuan bi day code len Github...
echo ------------------------------------------

:: Thêm tất cả thay đổi
git add .

:: Commit với nội dung đã nhập
git commit -m "%msg%"

:: Đẩy lên nhánh main (hoặc master tùy repo của bạn)
git push origin main

echo ------------------------------------------
echo [OK] Da cap nhat thanh cong!
echo ------------------------------------------
pause