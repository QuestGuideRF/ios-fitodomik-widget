1. **Откройте Xcode** → File → New → Project → iOS App
   - Название: `FitoDomik`
   - Interface: SwiftUI
2. **Добавьте Widget Extension**
   - File → New → Target → Widget Extension
   - Название: `FitoDomikWidget`
3. **Настройте App Groups** (в обоих targets!)
   - Signing & Capabilities → + Capability → App Groups
   - Создайте: `group.com.fitodomik.widget`
4. **Скопируйте файлы** из репозитория:
   - `FitoDomikApp/` → в основное приложение
   - `FitoDomikWidget/` → в widget extension
5. **Проверьте WidgetSettings.swift**
   - В File Inspector отметьте оба targets ✅
6. **Запустите приложение** (Cmd+R)
7. **Откройте fitodomik.online/get_token.php** и скопируйте User ID
8. **В приложении:**
   - Введите User ID
   - Выберите тему: ☀️ Светлая / 🌙 Темная / 🌱 Зеленая
   - Нажмите "Сохранить"
9. **Долгое нажатие** на домашний экран
## ❗ Важно
- App Groups должен быть в **ОБОИХ** targets!
## 🐛 Не работает?
**Виджет показывает "--":**
- Откройте приложение → Сохраните настройки еще раз
- Подождите 1-2 минуты
**Тема не меняется:**
- Удалите виджет → Добавьте заново
**Ошибка компиляции:**
- Clean Build Folder (Shift+Cmd+K)

- Проверьте Target Membership для WidgetSettings.swift


---
Автор: legenda_god
Telegram: https://t.me/FitoDomik
