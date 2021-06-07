document.addEventListener("turbolinks:load", function () {
    $('#sortable-btn').click(function () {
        console.log("111")
        $('#actions').toggleClass("d-none")
    })
});
