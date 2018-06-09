/* jquery.focus.js start */
(function(root, factory) {

  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports)
      module.exports = factory(global.$);
    exports = factory(global.$);
  } else {
    factory(root.$);
  }

}(this, function($) {

  $.fn.focusBegin = function() {
    return this.each(function() {
      var element = $(this)[0];

      if ($(this).is('textarea')) {
        element.focus();
        element.setSelectionRange(0, 0);
      } else if ($(this).is('input')) {
        element.selectionStart = 0;
        element.selectionEnd = 0;
        element.focus()
      } else {
        var range = document.createRange();
        var selection = window.getSelection();
        range.selectNodeContents(element);
        range.collapse(true);
        selection.removeAllRanges();
        selection.addRange(range);
      }
    });
  };

  $.fn.focusEnd = function() {
    return this.each(function() {
      var element = $(this)[0];

      if ($(this).is('textarea')) {
        element.focus();
        element.setSelectionRange($(this).val().length, $(this).val().length);
      } else if ($(this).is('input')) {
        element.selectionStart = element.value.length;
        element.selectionEnd = element.value.length;
        element.focus();
      } else {
        var range = document.createRange();
        var selection = window.getSelection();
        range.selectNodeContents(element);
        range.collapse(false);
        selection.removeAllRanges();
        selection.addRange(range);
      }
    });
  };

}));
/* jquery.focus.js end */

var replyTo = function(username) {
    var atString = '@' + username + "\u00a0", editorName, comment, oldContent, newContent;
    if($('.wysibb-body').length>0) {
        editorName = 'wysibb';
        comment = $('.wysibb-body');
        oldContent = comment.text();
        if(oldContent.length == 0) {
            $('#editor').insertAtCursor(atString);
        } else if ( oldContent.length>0 && oldContent != atString ) {
            $('#editor').insertAtCursor('<br>'+atString);
        }
        scrollToAnchor(comment);
        return;
    } else if($('.simditor-body').length>0) {
        editorName = 'simditor';
        comment = $('.simditor-body');
        oldContent = comment.html();
        oldText = comment.text();
    } else {
        editorName = 'smd';
        comment = $('#editor');
        oldContent = comment.val();
    } 

    newContent = '';
    scrollToAnchor(comment);
    if( editorName == 'smd') {
        if(oldContent.length > 0){
            if (oldContent != atString) {
                newContent = oldContent + "\n" + atString;
            }
        } else {
            newContent = atString;
        }
        comment.val(newContent);
    } else {
        if(oldText.length>0){
            if (oldText != atString) {
                newContent = oldContent + "<br />" + atString;
            }
        } else {
            newContent = atString;
        }
        comment.html(newContent);
    }
    comment.focusEnd();
}

var insertAtCursor= function(target, text) {
    var postion = target.selection('getPos');
    target.selection('insert',{text: text, mode: 'after'}).selection('setPos', {start: postion.end+text.length, end: postion.end+text.length});
}

var scrollToAnchor = function(anchor) {
    var fixedBar = $('.navbar-fixed-top');
    var fixedBarHeight = 0;
    if (fixedBar.length > 0) {
        fixedBarHeight = fixedBar.height();
    }
    if(anchor.length > 0){
        var t = anchor.offset().top - fixedBarHeight;
        $("html,body").animate({scrollTop : t}, {queue : false});
    }
}

var chooseNode = function(node) {
    $(".nodes-select2").val(node).trigger("change");
}

$(function(){
    var anchor = $("#"+window.location.hash.substr(1));
    scrollToAnchor(anchor);
});

$(function(){
    $('.link-external a[href^=http]')
        .not('[href*="'+location.hostname+'"]')
        .attr({target:"_blank"})
        .addClass("external");
});

$(function(){
    $('img.lazy').lazyload();
});

$(function(){

    if ($('.content').length>0) {
        var min=12, max=18;
        var elm = $('.content');
        var size = elm.css('fontSize').replace('px', '');

        $('.fontsize-plus').click(function() {
            if (size<max) {
                size++;
                elm.css({'fontSize' : size});
            }
            return false;   
        });

        $('.fontsize-minus').click(function() {
            if (size>min) {
                size--;
                elm.css({'fontSize' : size});
            }
            return false;   
        });
    }
});

var showBaiduShare = function(target){
    var shares = {
     'weibo': ['tsina', '分享到新浪微博'],
     'weixin': ['weixin', '分享到微信'],
     'share-alt': ['more', ''],
    };
    $.each(shares, function(name, item){
        $(target).append('<a href="#" class="bds bds_'+item[0]+' fa fa-lg fa-'+name+'" data-cmd="'+item[0]+'" title="'+item[1]+'"></a>');
    });
}

$(function(){
    if ($('.bdsharebuttonbox').length>0) {
        showBaiduShare('.bdsharebuttonbox');
        window._bd_share_config={"common":{"bdSnsKey":{},"bdText":"","bdMini":"2","bdMiniList":false,"bdPic":"","bdStyle":"0","bdSize":"24"},"share":{"bdCustomStyle":"../static/css/share.css"}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
    }
});

$(function(){
    $('input#q').focus(function(){
        $(this).animate({width: "250"}, 'fast');
    })
    $('input#q').blur(function(){
        $(this).animate({width: "180"}, 'fast');
    })
});

$(function(){
    $('.navi-nodes-add').click(function(e) {
        e.preventDefault();
        if($(".navi-nodes tr").length == 1) {
            $(".navi-nodes tr .navi-nodes-del").show();
        }
        var last = $('.navi-nodes tr:last-child');
        var id = parseInt(last.attr('id').replace('node_', ''))+1;
        var newNode = last.clone(true).attr('id', 'node_'+id);
        newNode.find('.node-id').val('').attr('id', 'navinode-'+id+'-node_id').attr('name', 'NaviNode['+id+'][node_id]');
        newNode.find('.visible').prop('checked', false).attr('id', 'navinode-'+id+'-visible').siblings('input').andSelf().attr('name', 'NaviNode['+id+'][visible]');
        newNode.find('.sortid').val('').attr('id', 'navinode-'+id+'-sortid').attr('name', 'NaviNode['+id+'][sortid]');
        $('.navi-nodes').append(newNode);
    });
    $('.navi-nodes-del').on("click", function () {
        $(this).closest('tr').remove();
        if($(".navi-nodes tr").length == 1) {
            $(".navi-nodes tr .navi-nodes-del").hide();
        }
    });
});

$(function(){
    var authInfo = {
        title: {qq:'qq登录', weibo:'微博登陆', weixin:'微信登录', weixinmp:'微信公众平台'},
        clientId: {qq:'appid', weibo:'App Key'},
        clientSecret: {qq:'appkey', weibo:'App Secret'},
    };

    if($(".auth-items div.auth-item").length == 1) {
        $(".auth-items div.auth-item .auth-item-del").hide();
    }

    $('.auth-item-add').click(function(e) {
        e.preventDefault();
        if($(".auth-items div.auth-item").length == 1) {
            $(".auth-items div.auth-item .auth-item-del").show();
        }
        var last = $('.auth-items div.auth-item').last();
        var id = parseInt(last.attr('id').replace('auth_', ''))+1;
        var newNode = last.clone(true).attr('id', 'auth_'+id);
        newNode.find('.auth-item-id').text('设定'+id);
        newNode.find('.auth-key').each(function(index, el){
            $(el).attr('id', 'setting-'+id+'-'+index+'-key').attr('name', 'Setting['+id+']'+'['+index+'][key]');
        });
        newNode.find('.auth-value').each(function(index, el){
            $(el).val('').attr('id', 'setting-'+id+'-'+index+'-value').attr('name', 'Setting['+id+']'+'['+index+'][value]');
        });
        newNode.find('.auth-index').val(0);
        newNode.find('.auth-sortid').val( parseInt($('.auth-sortid', last).val())+1 );
        $('.auth-items').append(newNode);
    });
    $('.auth-item-del').on("click", function () {
        $(this).closest('div.auth-item').remove();
        if($(".auth-items div.auth-item").length == 1) {
            $(".auth-items div.auth-item .auth-item-del").hide();
        }
    });
    $('.auth-type').on('change', function(){
        type = $(this).val();
        authItem = $(this).closest('.auth-item');

        $('.auth-item-id', authItem).text(type+'登录设定');
        $('.auth-title', authItem).val( authInfo['title'][type]===undefined?type+'登录':authInfo['title'][type] );
        $('.auth-clientId', authItem).closest('div').siblings('label').text( authInfo['clientId'][type]===undefined?'clientId':authInfo['clientId'][type] );
        $('.auth-clientSecret', authItem).closest('div').siblings('label').text( authInfo['clientSecret'][type]===undefined?'clientSecret':authInfo['clientSecret'][type] );
    });
});

$(function(){
    $('#exampleModal').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget);
      var modal = $(this);
      modal.find('.thanks-to').text(button.data('author'));
      modal.find('.good').attr('id', button.attr('id'));
    });
    $('body').on('click', '.good', function(e) {
        self = $(this);
        params = self.attr('id').split('-');
        thanks = $('input.thanks-author:checked').prop("checked")===true?1:0;
        $.ajax({
            url: baseUrl+'/service/good',
            type: "POST",
            data: { type:params[1], id:params[2], thanks:thanks },
            success: function (data) {
                if(data.result == 1) {
                    $('#'+self.attr('id')+' .good-num').text(data.count);
                } else {
                    alert(data.msg);
                }
                $('#exampleModal').modal('hide');
            }
        });
    });
});

$(function(){
    $('body').on('click', '.favorite', function(e) {
        var title = {
            'favorite':{'user':'取消关注', 'topic':'取消收藏', 'node':'取消收藏'},
            'unfavorite':{user:'关注 Ta', topic:'收藏', node:'收藏'}
        };
        self = $(this);
        params = self.attr('params').split(' ');
        action = params[0];
        type = params[1];
        id = params[2];
        $.ajax({
            url: baseUrl+'/service/'+action,
            type: "POST",
            data: { type:type, id:id },
            success: function (data) {
                if(data.result == 1) {
                    count = $(".favorite-num", self).text();
                    if (action == 'favorite') {
                        count = count == ''?1:(parseInt(count) + 1);
                        $(".fa", self).removeClass('fa-star-o').addClass('fa-star');
                        $(self).attr({'title':title[action][type], 'params':'unfavorite '+type+' '+id});
                    } else {
                        count = (count == '' || count=='1')?'':(parseInt(count) - 1);
                        $(".fa", self).removeClass('fa-star').addClass('fa-star-o');
                        $(self).attr({'title':title[action][type], 'params':'favorite '+type+' '+id});
                    }
                    $(".favorite-num", self).text(count);
                    $(".favorite-name", self).text(title[action][type]);
                } else {
                    alert(data.msg);
                }
            }
        });
    });
});
/*
var favorite = function(e, type, id) {
    var title = {'user':'取消关注', 'topic':'取消收藏', 'node':'取消收藏'};
    $.ajax({
        url:baseUrl+"/service/favorite",
        type: "POST",
        data: { type:type, id: id },
        success: function (data) {
            if(data.result == 1) {
                count = $(".favorite-num", e).text();
                if (count == '') {
                    count = 1;
                } else {
                    count = parseInt(count) + 1;
                }
                $(".favorite-num", e).text(count);
                $(".favorite .fa").removeClass('fa-star-o').addClass('fa-star');
                $(".favorite .favorite-name").text(title[type]);
                $(".favorite").attr({'onclick':'javascript:unfavorite(\''+type+'\','+id+')', 'title':title[type]});
            } else {
                alert(data.msg);
            }
        }
    });
};

var unfavorite = function(type, id) {
    var title = {user:'关注 Ta', topic:'收藏', node:'收藏'};
    $.ajax({
        url:baseUrl+"/service/unfavorite",
        type: "POST",
        data: { type:type, id: id },
        success: function (data) {
            if(data.result == 1) {
                count = $(".favorite-num").text();
                if (count == '' || count=='1') {
                    count = '';
                } else {
                    count = parseInt(count) - 1;
                }
                $(".favorite-num").text(count);
                $(".favorite .fa").removeClass('fa-star').addClass('fa-star-o');
                $(".favorite .favorite-name").text(title[type]);
                $(".favorite").attr({'onclick':'javascript:favorite(\''+type+'\','+id+')', 'title':title[type]});
            } else {
                alert(data.msg);
            }
        }
    });
};
*/
$(function(){
    $('.img-zoom img.lazy').each(function( index ) {
        if ( $(this).parents('a').length == 0 ) {
            href = $(this).attr('data-original')?$(this).attr('data-original'):$(this).attr('src');
            $(this).wrap('<a href="'+href+'" data-lightbox="roadtrip"></a>');
        }
    });
});

$(function(){
    var pocounter;
    $("*[data-poload]").on("mouseenter", function () {
            var _this = this;
            $.get($(_this).data('poload'),function(d) {
                $(_this).popover({container: 'body', trigger: "manual" , html: true, animation:false, content: d}).popover('show');
            });

            // clear the counter
            clearTimeout(pocounter);

            // start new timeout to show popover
            pocounter = setTimeout(function(){
                if($(_this).is(':hover'))
                {
                    $(_this).popover("show");
                }
                $(".popover").on("mouseleave", function () {
                    $(_this).popover('destroy');
                });
            }, 400);

        }).on("mouseleave", function () {
            var _this = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    $(_this).popover("destroy");
                }
            }, 300);
    });
});

$(function(){
    $("#weixinmp").popover({
        html: true,
        placement: 'left', 
        trigger: 'manual', 
        content: '<div id="weixin-qrcode" style="width:128px;height:128px;"></div>', 
        title : '<span class="text-info"><strong>微信扫一扫</strong></span> <button type="button" id="weixinmp-close" class="popover-close close">&times;</button>'
    }).on('shown.bs.popover', function(e){
        var popover = $(this);
        $(this).parent().find('div.popover .popover-close').on('click', function(e){
          popover.popover('hide');
        });
    });

    $("#weixinmp").click(function () {
        $(this).popover('show');
        $("#weixin-qrcode").qrcode({width: 128,height: 128,text: $(this).attr('link')});
    });
});
