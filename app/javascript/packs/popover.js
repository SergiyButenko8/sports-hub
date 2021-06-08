document.addEventListener("turbolinks:load", function () {
    $('#sortable-btn').click(function () {
        $('#actions').toggleClass("d-none")
    })

    $('.search-init').click(function(){
        $('.search-init').toggleClass('d-none');
        $('.search-expanded').toggleClass('d-none');
    })
});
