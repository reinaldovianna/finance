(function(){$("#add-store").click(function(t){return t.preventDefault(),t.stopPropagation(),this.add_store_path=$(this).attr("href"),$.get(this.add_store_path,function(t){return $("#content-stores").append("<div class='content-store'>"+t.form+"</div>")})})}).call(this),removeStore=function(t){return $remove_store_path=t.attr("href"),$.get($remove_store_path).done(function(){return t.parents(".content-store").remove()}(this))},$(document).on("click",".remove-store",function(t){t.preventDefault(),removeStore($(this))}),$(document).on("click","#add-store",function(t){t.preventDefault(),t.stopPropagation(),$add_store_path=$(this).attr("href"),$.get($add_store_path,function(t){$("#content-stores").append("<div class='content-store'>"+t.form+"</div>")})});