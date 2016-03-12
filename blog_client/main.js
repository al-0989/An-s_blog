$(document).ready(function(){

  // Ajax request that will generate all the questions
  $.ajax({
    url: "http://localhost:3000/posts.json",
    method: "GET",
    error: function(){
      alert("Please reload!");
    },
    success: function(data){
      var posts = data.posts;
      $("#posts").html("");
      for(var i = 0; i < posts.length; i++){
        var template = $("#all-posts").html();
        // Mustache render method takes in a template and what the {{}} is to be filled with
        var renderedHtml = Mustache.render(template, posts[i]);
        $("#posts").append(renderedHtml);
      }
    }
  }); // End of ajax request to generate all questions

  // Ajax request to show post details
  $("#posts").on("click", "a", function(){ // When a link is clicked show the post
    $.ajax({
      // path is http://localhost:3000/posts/post_id.json
      url: "http://localhost:3000/posts/" + $(this).data('id') + ".json",
      method: "GET",
      error: function(){
        alert("Post failed to load");
      },
      success: function(data){
        var post = data.post;
        var template = $("#post-details").html();
        var renderedHtml = Mustache.render(template, post);
        $("#post-show-container").html(renderedHtml).hide(); // Render the post in the post show container
        $("#posts").fadeOut(500, function(){
          $("#post-show-container").fadeIn(500);
        });
      }
    }); // End of Ajax request
  });// End of show post

  // Ajax request to show all comments
  $("#post-show-container").on("click", "#show-comments", function(){
    console.log($(this).data("p-id"));
    var commentId = $(this).data("p-id");
    $.ajax({
      url: "http://localhost:3000/posts/" + commentId + "/comments.json",
      method: "GET",
      error: function (){
        alert("Post failed to load");
      },
      success: function(data){
        var comment = data.comments;
        var template = $("#comment").html();
        for(var i = 0; i < comment.length; i++){
          var renderedHtml= Mustache.render(template, comment[i]);
          $("#comments-container").append(renderedHtml);
        }
        $("#comments-container").show();
        $("#show-comments").html("Hide Comments");
        $("#show-comments").attr("id", "hide-comments");
        }
    });
  });

  // Back button
  $("#post-show-container").on("click", "a#back", function(){
    $("#post-show-container").fadeOut(500, function(){
      $("#posts").fadeIn(500);
    });
  });

  // Hide all comments
  $("#post-show-container").on("click", "a#hide-comments", function(){
      $("#comments-container").fadeOut(500, function(){
        $("#comments-container").children().hide();
        $("#hide-comments").html("Show Comments");
        $("#hide-comments").attr("id", "show-comments");
      });
  });
}); // End of the document ready
