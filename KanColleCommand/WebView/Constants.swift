import Foundation
import UIKit

struct Constants {

    static let START_EVENT = Notification.Name.init("GameStart")

    static let RELOAD_GAME = Notification.Name.init("ReloadGame")

    static let HOME_PAGE = "http://www.dmm.com/netgame/social/-/gadgets/=/app_id=854854/"
    
    static let OOI = "http://ooi.moe"

    static let FULL_SCREEN_SCRIPT = "javascript:(($,_)=>{const html=$.documentElement,gf=$.getElementById('game_frame'),gs=gf.style,gw=gf.offsetWidth,gh=gw*.6;let vp=$.querySelector('meta[name=viewport]'),t=0;vp||(vp=$.createElement('meta'),vp.name='viewport',$.querySelector('head').appendChild(vp));html.style.overflow='hidden';$.body.style.cssText='min-width:0;overflow:hidden;margin:0';$.querySelector('.dmm-ntgnavi').style.display='none';$.querySelector('.area-naviapp').style.display='none';$.getElementById('ntg-recommend').style.display='none';gs.position='fixed';gs.marginRight='auto';gs.marginLeft='auto';gs.top='-16px';gs.right='0';gs.zIndex='100';gs.transformOrigin='50% 16px';if(!_.kancolleFit){const k=()=>{const w=html.clientWidth,h=_.innerHeight;w/h<1/.6?gs.transform='scale('+w/gw+')':gs.transform='scale('+h/gh+')';w<gw?gs.left='-'+(gw-w)/2+'px':gs.left='0'};_.addEventListener('resize',()=>{clearTimeout(t);t=setTimeout(k,10)});_.kancolleFit=k}kancolleFit()})(document,window);"

    static let TAG = "Handled"

    static let SNIFFER_SCRIPT = "!function(t){function r(i){if(n[i])return n[i].exports;var e=n[i]={exports:{},id:i,loaded:!1};return t[i].call(e.exports,e,e.exports,r),e.loaded=!0,e.exports}var n={};return r.m=t,r.c=n,r.p=\"\",r(0)}([function(t,r,n){n(1)(window)},function(t,r){t.exports=function(t){t.hookAjax=function(t){function r(r){return function(){var n=this.hasOwnProperty(r+\"_\")?this[r+\"_\"]:this.xhr[r],i=(t[r]||{}).getter;return i&&i(n,this)||n}}function n(r){return function(n){var i=this.xhr,e=this,o=t[r];if(\"function\"==typeof o)i[r]=function(){t[r](e)||n.apply(i,arguments)};else{var h=(o||{}).setter;n=h&&h(n,e)||n;try{i[r]=n}catch(t){this[r+\"_\"]=n}}}}function i(r){return function(){var n=[].slice.call(arguments);if(!t[r]||!t[r].call(this,n,this.xhr))return this.xhr[r].apply(this.xhr,n)}}return window._ahrealxhr=window._ahrealxhr||XMLHttpRequest,XMLHttpRequest=function(){this.xhr=new window._ahrealxhr;for(var t in this.xhr){var e=\"\";try{e=typeof this.xhr[t]}catch(t){}\"function\"===e?this[t]=i(t):Object.defineProperty(this,t,{get:r(t),set:n(t)})}},window._ahrealxhr},t.unHookAjax=function(){window._ahrealxhr&&(XMLHttpRequest=window._ahrealxhr),window._ahrealxhr=void 0},t.default=t}}]);hookAjax({onreadystatechange:function(xhr){if(xhr.status==200&&xhr.readyState==4){if(window.JsBridge){window.JsBridge.onResponseWithUrlHeaderBody(xhr.xhr.responseURL,xhr.xhr.requestParam,xhr.responseText)}}},send:function(arg,xhr){xhr.requestParam=arg[0]}});"
    
    static let DMM_COOKIES = "javascript:document.cookie='ckcy=1;expires=Sun, 04 Feb 2029 09:00:09 GMT;domain=osapi.dmm.com;path=/';document.cookie='ckcy=1;expires=Sun, 04 Feb 2029 09:00:09 GMT;domain=203.104.209.7;path=/';document.cookie='ckcy=1;expires=Sun, 04 Feb 2029 09:00:09 GMT;domain=www.dmm.com;path=/netgame/';document.cookie='ckcy=1;expires=Sun, 04 Feb 2029 09:00:09 GMT;domain=log-netgame.dmm.com;path=/';"
    
    static let darkBG = "javascript:var style = document.createElement(\"style\");style.type = \"text/css\";var head = document.head;head.appendChild(style);style.sheet.insertRule(\"* { color: #aaa !important; background-color: #000 !important; border-color: currentColor !important; }\");completion(true);;"
    
    static let ios15Fix = "javascript:window.open(gadgetInfo.URL)"
    
    static let iframeFix = "javascript:var sectionWrap = document.getElementById('sectionWrap');sectionWrap.parentNode.removeChild(sectionWrap);var spacing_top = document.getElementById('spacing_top');spacing_top.parentNode.removeChild(spacing_top);var debugDiv = document.getElementById('debugDiv');debugDiv.parentNode.removeChild(debugDiv);"
}
