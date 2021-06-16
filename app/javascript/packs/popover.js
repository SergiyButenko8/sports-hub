document.addEventListener("turbolinks:load", function () {
    $('#sortable-btn').click(function () {
        $('#actions').toggleClass("d-none")
    })

    $('.search-init').click(function(){
        $('.search-init').toggleClass('d-none');
        $('.search-expanded').toggleClass('d-none');
    })

    $("#categories-area").on("click", ".cat-btn", function(){
        $(".cat-label").removeClass("ia-active")
        $(this).closest(".cat-label").addClass("ia-active")
    })
    $("#sub-categories-area").on("click", "a.sub-btn", function(){
        $(".sub-label").removeClass("ia-active")
        $(this).closest(".sub-label").addClass("ia-active")
    })
    $("#teams-area").on("click", "a.team-btn", function(){
        $(".team-label").removeClass("ia-active")
        $(this).closest(".team-label").addClass("ia-active")
    })
});


