# launchctl-in-mac
在 Mac OSX 中，如何使用排程工具，有點複雜，要仔細學習囉！

## 簡介
先簡介一下 Mac OSX 有哪幾種排程的指令：

- at：可安排工作於指定的時間點執行工作。
- crontab：可安排工作於循環的時間點，做循環性的排程工作。
- launchctl：功能較豐富，可包含以上兩個指令所擁有的大部分功能。

優缺點比較：

<table>
    <tr>
        <th align="center">指令</th>
        <th>優點</th>
        <th>缺點</th>
    </tr>
    <tr>
        <td align="center">at</td>
        <td>簡單易懂、指定時間的最小單位為 1 秒</td>
        <td>只能執行一次</td>
    </tr>
    <tr>
        <td align="center">crontab</td>
        <td>簡單易懂</td>
        <td>腳本文件必須在系統預設的資料夾內，無法寫在任意位置。<br/>指定時間的最小單位為分鐘。</td>
    </tr>
    <tr>
        <td align="center">launchctl</td>
        <td>功能豐富，可載入多個排程腳本</td>
        <td>邏輯較複雜。<br/>中文資源少。<br/>指定時間的最小單位為 10 秒。<br/>只有Mac OS X 有支援。</td>
    </tr>
</table>

## 開始學習

基於種種考量，我們選擇使用 launchctl。

### Work Flow
lanuchctl 的工作流程是：

1. 編輯工作腳本：使用 xml，附檔名為 plist。
2. 載入工作腳本：即根據腳本內設定的條件進行工作。
3. 列出工作：可列出目前有哪些工作正在排程運行中。
4. 刪除工作。

### Documention
因為太多了，我就不翻譯了，請各位自己看。

#### 腳本文件說明
在指令模式輸入 `man launchd.plist` 可以看到完整的文件或進入 [Apple 官方](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html#//apple_ref/doc/man/5/launchd.plist) 直接看說明。

#### 指令功能
這裡只列出常用的幾個：

- `lanuchctl load <filepath>` : 載入腳本
- `lanuchctl remove <name>` : 移除腳本（已經在排程中的工作）。
- `lanuchctl list` : 會列出系統中目前正在執行的工作有哪些，如果要過濾出想看的部份，可以使用 grep 來進行結果的過濾，例如：`lanuchctl list | grep 'apple'`
- `man launchctl` : 列出 launchctl 的詳細說明，都英文啦。

## 正式開始
練習一次就懂了。

### a. 建立腳本
首先在 plist 資料夾內建立一個文字檔案命名為 `com.exampl.hello.plist`，內容輸入如下：
<pre>
`<?xml version="1.0" encoding="UTF-8"?>`
`<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">`
`<plist version="1.0">`
    `<dict>`
        `<key>`Label`</key>`
        `<string>`com.exampl.hello`</string>`
        `<key>`ProgramArguments`</key>`
        `<array>`
            `<string>`<絕對路徑>/launchctl-in-mac/bin/hello.sh`</string>`
        `</array>`
        `<key>`StartInterval`</key>`
        `<integer>`10`</integer>`
        `<key>`RunAtLoad`</key>`
        `<true/>`
    `</dict>`
`</plist>`
</pre>

###### 注意：上面的 <絕對路徑> 會依照個人的電腦而有所不同，請使用 `pwd` 指令來確認目前你的資料夾所在位置。

腳本內容的意思是，先制定 xml 的預設框架，然後內容從 `<dict>` 開始

- `Label`: 給腳本一個名稱。
- `ProgramArguments`: 要執行的任務內容，我們執行一個 shell 檔案。
- `StartInterval`: 迴圈，這裡設定每十秒執行一次。
- `RunAtLoad`: 當載入時，先執行一次。

補充說明 bin/hello.sh 的內容`date +'%Y/%m/%d %H:%M' >> /tmp/helloExample.log
` ：會寫入時間資訊到 /tmp/helloExample.log 這個檔案。

### b. 載入腳本
輸入 

`lanuchctl load plist/com.exampl.hello.plist`

即完成載入。如果要確認是否有載入可以輸入

`launchctl list | grep 'hello'`

另一個方法可以確認是否有正確執行任務，可以輸入

`tail -f /tmp/helloExample.log`

會看到時間資訊，且每十秒會更新一次。

### c. 移除腳本
輸入 `lanuchctl remove com.exampl.hello`。

## Makefile
這個 repo 是為了要排程 selenium 測試所建立，所以建立了一個 Makefile    方便執行排程進行測試。

1. 記得先修改腳本，符合你的需求：執行時間 和 檔案路徑。(.plist .sh 這兩個檔案都要檢查)
2. 執行 `make start` 進行載入 selenuim 排程。
3. 執行 `make stop` 進行移除 selenuim 排程。
