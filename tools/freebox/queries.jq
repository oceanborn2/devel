.[] |   {
       id: .details.channelNumber,
       fbm: $fbmod,
       logo:  .image.src,
       cn: .details.channelNumber,
       name:  .details.title,
       desc:  .details.description,
       price: (.details.price // 0.00),
       stp:   .details.isPriceStartingAt,
       cat:   [ .details.categories.[] ] | join(", "), #removed |tostring
       res:   [ .details.screenResolution.[] ] | join(" "),
       vis:   .details.freeboxs[] | select(.name == $fbmod).isVisible, #removed | {isVisible}.isVisible,
   }