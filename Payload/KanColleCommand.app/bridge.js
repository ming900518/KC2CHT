!function (t) {
    function r(i) {
        if (n[i]) return n[i].exports;
        var e = n[i] = {exports: {}, id: i, loaded: !1};
        return t[i].call(e.exports, e, e.exports, r), e.loaded = !0, e.exports
    }

    var n = {};
    return r.m = t, r.c = n, r.p = "", r(0)
}([function (t, r, n) {
    n(1)(window)
}, function (t, r) {
    t.exports = function (t) {
        t.hookAjax = function (t) {
            function r(r) {
                return function () {
                    var n = this.hasOwnProperty(r + "_") ? this[r + "_"] : this.xhr[r], i = (t[r] || {}).getter;
                    return i && i(n, this) || n
                }
            }

            function n(r) {
                return function (n) {
                    var i = this.xhr, e = this, o = t[r];
                    if ("function" == typeof o) i[r] = function () {
                        t[r](e) || n.apply(i, arguments)
                    }; else {
                        var h = (o || {}).setter;
                        n = h && h(n, e) || n;
                        try {
                            i[r] = n
                        } catch (t) {
                            this[r + "_"] = n
                        }
                    }
                }
            }

            function i(r) {
                return function () {
                    var n = [].slice.call(arguments);
                    if (!t[r] || !t[r].call(this, n, this.xhr)) return this.xhr[r].apply(this.xhr, n)
                }
            }

            return window._ahrealxhr = window._ahrealxhr || XMLHttpRequest, XMLHttpRequest = function () {
                this.xhr = new window._ahrealxhr;
                for (var t in this.xhr) {
                    var e = "";
                    try {
                        e = typeof this.xhr[t]
                    } catch (t) {
                    }
                    "function" === e ? this[t] = i(t) : Object.defineProperty(this, t, {get: r(t), set: n(t)})
                }
            }, window._ahrealxhr
        }, t.unHookAjax = function () {
            window._ahrealxhr && (XMLHttpRequest = window._ahrealxhr), window._ahrealxhr = void 0
        }, t.default = t
    }
}]);
hookAjax({
    onreadystatechange: function (xhr) {
        if (xhr.status == 200 && xhr.readyState == 4) {
            // if (window.JsBridge) {
            //     window.JsBridge.onResponseWithUrlHeaderBody(xhr.xhr.responseURL, xhr.xhr.requestParam, xhr.responseText)
            // }
            if (window.JsBridge) {
                var data = {url: xhr.xhr.responseURL, request: xhr.xhr.requestParam, response: xhr.responseText};
                window.JsBridge.callNativeBridge("onResponse", JSON.stringify(data))
            }
        }
    }, send: function (arg, xhr) {
        xhr.requestParam = arg[0]
    }
});
!(function () {
    if (window.JsBridge) {
        return;
    }
    window.JsBridge = {
        callNativeBridge: callNativeBridge,
    };

    function callNativeBridge(name, data) {
        var url = "kcwebview://" + name + "/params?" + data;
        var iFrame;
        iFrame = document.createElement("iframe");
        iFrame.setAttribute("src", url);
        iFrame.setAttribute("style", "display:none;");
        iFrame.setAttribute("height", "0px");
        iFrame.setAttribute("width", "0px");
        iFrame.setAttribute("frameborder", "0");
        document.body.appendChild(iFrame);
        iFrame.parentNode.removeChild(iFrame);
        iFrame = null;
    }
})();

