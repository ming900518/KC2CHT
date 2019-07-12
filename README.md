# iKanColleCommand with OOI and Chinese Traditional Translation
修改自原作者NGA用戶亖葉(UID42542015)於2019年7月4號發佈的iKanColleCommand專案，提供iOS用戶穩定的艦隊收藏遊戲環境和基本的輔助程式功能。

[NGA帖子連結](https://ngabbs.com/read.php?tid=17767319)

[原版源碼GitHub連結](https://github.com/lhc-clover/iKanColleCommand)

本修改版使沒有使用VPN遊玩艦隊收藏及使用繁體中文的玩家也可以使用這個App。

修改項目如下：

1. 將起始網頁設定為[OOI艦娘在線緩存系統](http://ooi.moe/)
，可繞過DMM登入地區檢查，客戶端不必掛VPN或修改Cookies便可遊玩。
2. 繁體中文化（尚未完善）
3. 允許畫面縮放（自動全螢幕將於未來版本加入）
4. 功能調整
5. 保留原本版本號但加註TW.CHT（臺灣繁體中文）和OOI以和原版做區別
6. 程式名稱縮短為KC2(OOI)
7. Bundle ID從cn.cctech.kancolle.command改為tw.cctech.kancolle.command.ooi

### 本專案不會用於盈利，根據原作者要求也不允許任何形式的收費。

### 轉發需註明原作者-NGA用戶亖葉(UID42542015)及本頁面的連結。

這裡主要只提供IPA下載，根據原作者希望，之後會將源碼使用GitHub的Fork功能（摸索中）提供回原專案。

## 安裝方式

IPA檔提供於Release頁面：https://github.com/ming900518/KC2-OOI-/releases

### 目前最新版本為1.0(TW.CHT.Beta6-OOI)，我強烈建議使用最新版本進行遊玩。

理論上支援所有iOS 11.4以上的所有iDevice（iPhone 5以下的32位元設備不支援），已經在iPhone 6s Plus（iOS 13 Developer Beta 3）上測試過功能正常。

非越獄用戶安裝可以參考https://mrmad.com.tw/cydia-impactor
，非企業簽證（沒有付蘋果299美金的人）的用戶每七天需要重新簽名安裝。

有越獄用戶安裝可以參考https://mrmad.com.tw/reprovision
，可以自動重新簽名，或使用AppSync直接Fake Sign（進階）。

#### 由於記憶體洩漏問題（田中的鍋），非常不建議以下1GB記憶體（RAM，非儲存空間）的設備遊玩

* iPhone 6

* iPhone 6 Plus

* iPhone 5s

* iPod 6 Generation

* iPad Mini 3

* iPad Mini 4

* iPad Air

### Mac及PC用戶請使用電腦的輔助程式（KCV, KC3, Poi等），Android用戶請愛用官方App搭配Kcanotify，這App是給iOS用的。

## 聯繫我(Bug回報或功能建議)
Email:ming900518@gmail.com

巴哈姆特的文章為我朋友代發，有問題和建議也可以直接留言在下面喔！
## 助人為快樂之本
徵求
1. 精通Swift的真神
2. 有企業簽證/TestFlight的大佬
3. 有除了iPhone 6s Plus以外的設備，會編譯的提督
4. 會用GitHub的提督

聯繫我，讓我們一起造福世界上使用iOS設備的提督!
