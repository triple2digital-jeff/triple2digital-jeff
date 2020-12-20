
dataConfirmModal.setDefaults({
    title: 'Confirmation required!',
    commit: 'Confirm',
    cancel: 'Cancel'
});

$(document).ready(function(){
    $("tr").on('click', function() {
        window.location = $(this).data("link")
    });

    $( ".select2" ).select2({search: false});

    $('.datepicker').datepicker({autoclose: true, format: 'yyyy-mm-dd'});

    $("#dttb").dataTable({searching: false, paging: false, info: false});

    var $d2 = $("#user_slider");

    $d2.ionRangeSlider({
        skin: "big",
        type: "double",
        min: 10,
        max: 150,
        from: 20,
        to: 50,
        step: 1,
        grid: true,
        onStart: function (data) {
            // Called right after range slider instance initialised

            // console.log(data.input);        // jQuery-link to input
            // console.log(data.slider);       // jQuery-link to range sliders container
            // console.log(data.min);          // MIN value
            // console.log(data.max);          // MAX values
            console.log(data.from);         // FROM value
            // console.log(data.from_percent); // FROM value in percent
            // console.log(data.from_value);   // FROM index in values array (if used)
            console.log(data.to);           // TO value
            // console.log(data.to_percent);   // TO value in percent
            // console.log(data.to_value);     // TO index in values array (if used)
            // console.log(data.min_pretty);   // MIN prettified (if used)
            // console.log(data.max_pretty);   // MAX prettified (if used)
            // console.log(data.from_pretty);  // FROM prettified (if used)
            // console.log(data.to_pretty);    // TO prettified (if used)
        },



        onFinish: function (data) {
            // Called then action is done and mouse is released
            console.log(data.from);
            console.log(data.to);
            $("#min_age").val(data.from);
            $("#max_age").val(data.to);
        },

        onUpdate: function (data) {
            // Called then slider is changed using Update public method

            console.log(data.from_percent);
        }
    });

    var d2_instance = $d2.data("ionRangeSlider");
    var from_2 = $("#min_age").val();
    var to_2 = $("#max_age").val();
   if(d2_instance!=undefined) {
       d2_instance.update({
           from: from_2,
           to: to_2
       });
   }


    var $d1 = $("#service_slider");

    $d1.ionRangeSlider({
        skin: "big",
        type: "double",
        min: 1,
        max: 1000,
        from: 10,
        to: 100,
        step: 1,
        grid: true,
        onStart: function (data) {
            // Called right after range slider instance initialised

            // console.log(data.input);        // jQuery-link to input
            // console.log(data.slider);       // jQuery-link to range sliders container
            // console.log(data.min);          // MIN value
            // console.log(data.max);          // MAX values
            console.log(data.from);         // FROM value
            // console.log(data.from_percent); // FROM value in percent
            // console.log(data.from_value);   // FROM index in values array (if used)
            console.log(data.to);           // TO value
            // console.log(data.to_percent);   // TO value in percent
            // console.log(data.to_value);     // TO index in values array (if used)
            // console.log(data.min_pretty);   // MIN prettified (if used)
            // console.log(data.max_pretty);   // MAX prettified (if used)
            // console.log(data.from_pretty);  // FROM prettified (if used)
            // console.log(data.to_pretty);    // TO prettified (if used)
        },



        onFinish: function (data) {
            // Called then action is done and mouse is released
            console.log(data.from);
            console.log(data.to);


            $("#min_price").val(data.from);
            $("#max_price").val(data.to);
        },

        onUpdate: function (data) {
            // Called then slider is changed using Update public method

            console.log(data.from_percent);
        }
    });
    var d1_instance = $d1.data("ionRangeSlider");
    var from = $("#min_price").val();
    var to = $("#max_price").val();
    if(d1_instance!=undefined) {
        d1_instance.update({
            from: from,
            to: to
        });
    }

    $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
        checkboxClass: 'icheckbox_flat-green',
        radioClass   : 'iradio_flat-green'
    });
    //Initialize Select2 Elements
    $('.select2').select2();



    $("#unlock_payment").on("click", function(e) {

        $.confirm({
            title: 'Confirm!',
            content: 'Are you sure, you want to unlock this payment?!',
            buttons: {
                confirm: function () {
                    $.alert('Payment has been unlocked!');
                },
                cancel: function () {
                    // $.alert('Canceled!');
                }
            }
        });
    });

});

