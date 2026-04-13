# Project Rules

## Alias
- `TG = telegram`

## Notification Convention
- 當使用者說「TG 通知我：<訊息>」時，代表要發送 Telegram 通知。
- 執行策略：只要收到 `TG` / `Telegram 通知` 指令且訊息內容完整，直接發送，不再額外詢問使用者確認。

## Telegram 技能使用方式
- 技能名稱：`telegram-notify`
- 用途：在任務完成、建置完成、或你指定時，發送 Telegram 訊息通知。
- 觸發語句：
  - `TG 通知我：<訊息>`
  - `Telegram 通知我：<訊息>`
- 預設收件人：使用技能 `.env` 內的 `TELEGRAM_CHAT_ID`。
- 可選參數：可指定 `chat_id` 覆寫預設收件人。

## 常用範例
- `TG 通知我：APK 編譯完成`
- `TG 通知我：測試全部通過，準備提交`

## 執行流程（Agent）
1. 解析使用者訊息，取得 `message`（必要）與 `chat_id`（可選）。
2. 不進行二次確認，直接呼叫腳本：`scripts/send_telegram.py` 發送通知。
3. 回報發送結果（成功/失敗原因）。

## 注意事項
- 訊息盡量使用純文字，避免特殊符號造成格式解析錯誤。
- 若回傳網路/權限錯誤，需在允許網路環境下重送。
