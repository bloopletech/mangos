var lastControllerLocation = "";

controllers.index = function(search, sort, sortDirection) {
  var _this = this;

  function sortFor(type) {
    if(type == "publishedOn") return function(book) {
      return book.publishedOn;
    };
    if(type == "pages") return function(book) {
      return book.pageUrls.length;
    };
    if(type == "title") return function(book) {
      return book.title.toLowerCase();
    };
  }

  function searchWords(books, search) {
    var words = _.partition(search.split(/\s+/), function(word) {
      return word.match(/^-/);
    });

    var includedWords = words[1];
    var excludedWords = words[0];

    function containsRegex(regex, book) {
      return book.title.match(regex);
    }

    _.each(includedWords, function(word) {
      books = _.filter(books, _.partial(containsRegex, RegExp(word, "i")));
    });

    _.each(excludedWords, function(word) {
      word = word.substr(1);
      books = _.reject(books, _.partial(containsRegex, RegExp(word, "i")));
    });

    return books;
  }

  var books = store;
  if(search && search != "") books = searchWords(books, search);
  if(!sort) sort = "publishedOn";
  books = _.sortBy(books, sortFor(sort));

  if(!sortDirection) sortDirection = "desc";
  if(sortDirection == "desc") books = books.reverse();

  this.init = function() {
    console.log("starting index");

    $("#search").bind("keydown", function(event) {
      event.stopPropagation();
      if(event.keyCode == 13) {
        event.preventDefault();
        utils.location({ params: [$("#search").val(), sort, sortDirection], hash: "1" });
      }
    });

    $("#clear-search").bind("click", function() {
      $("#search").val("");
      event.preventDefault();
      location.href = "#index!1";
    });

    $(".sort button").bind("click", function(event) {
      event.preventDefault();
      utils.location({ params: [search, $(this).data("sort"), sortDirection], hash: "1" });
    });

    $(".sort button").removeClass("active");
    $(".sort button[data-sort=" + sort + "]").addClass("active");

    $(".sort-direction button").bind("click", function(event) {
      event.preventDefault();
      utils.location({ params: [search, sort, $(this).data("sort-direction")], hash: "1" });
    });

    $(".sort-direction button").removeClass("active");
    $(".sort-direction button[data-sort-direction=" + sortDirection + "]").addClass("active");

    $("#view-index").css("display", "flex").addClass("current-view");
    $("title").text("Mangos");
  }

  this.render = function() {
    console.log("rendering");
    window.scrollTo(0, 0);

    //document.querySelector("manga-list").data = books;
    document.querySelector("manga-list").updateData(books);
    lastControllerLocation = location.hash;
  }

  this.destroy = function() {
    console.log("destroying index");
    $("#search").unbind("keydown");
    $("#clear-search").unbind("click");
    $(".sort button").unbind("click");
    $(".sort-direction button").unbind("click");
    $("#items").empty();
    $("#view-index").hide().removeClass("current-view");
  }
}
