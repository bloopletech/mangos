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

  var books = store;
  if(search && search != "") {
    var words = search.split(/\s+/);
    _.each(words, function(word) {
      regex = RegExp(word, "i");
      books = _.filter(books, function(book) {
        return book.title.match(regex);
      });
    });
  }
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

    $("#view-index").show().addClass("current-view");
    $("title").text("Mangos");

    $("#prev-page").click(function() {
      utils.page(utils.page() - 1);
    });

    $("#next-page").click(function() {
      utils.page(utils.page() + 1);
    });
  }

  function renderBooks(books) {
    var prev_page = $("#prev-wrapper").detach();
    var next_page = $("#next-wrapper").detach();

    $("#items").empty();

    $("#items").append(prev_page);

    _.each(books, function(book) {
      var item = $("<li>");
      var link = $("<a>");
      link.attr("href", "#show/" + book.key + "!1");
      link.attr("target", "_blank");
      var img = $("<img>");
      img.attr("src", book.thumbnailUrl);
      link.append(img);
      item.append(link);

      item.append('<div class="info-wrapper"><div class="info"><div class="title">' + book.title + '</div>' +
        '<img src="img/icons/page_white.png" title="Pages"> ' + book.pageUrls.length + '</div></div>');

      $("#items").append(item);
    });

    $("#items").append(next_page);
  }

  this.render = function() {
    var per_page = 500;

    renderBooks(utils.paginate(books, per_page));

    if(utils.page() == 1) $("#prev-wrapper").addClass("hidden");
    else $("#prev-wrapper").removeClass("hidden");

    if(utils.page() == utils.pages(books, per_page)) $("#next-wrapper").addClass("hidden");
    else $("#next-wrapper").removeClass("hidden");

    window.scrollTo(0, 0);

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
