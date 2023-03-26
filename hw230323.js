
//Вывести ТОП-1 стран по общей сумме пожертвований (страна + общая сумма).
db.donations.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "donator_id",
      foreignField: "id",
      as: "user"
    }
  },
  {
    $unwind: "$user"
  },
  {
    $group: {
      _id: "$user.country",
      total_donations: { $sum: "$amount" }
    }
  },
  {
    $sort: { total_donations: -1 }
  },
  {
    $limit: 1
  },
  {
    $project: {
      _id: 0,
      country: "$_id",
      total_donations: 1
    }
  }
]);

//Вывести страны со средней реакцией пользователей (напр., пользователи из США имеют сред.реакцию - 4).
db.users.aggregate([
  {
    $lookup: {
      from: "reactions",
      localField: "id",
      foreignField: "user_id",
      as: "user_reactions"
    }
  },
  {
      $unwind: '$user_reactions'
  },
  {
    $group: {
      _id: "$country",
      avg_reaction: { $avg: "$user_reactions.value" }
    }
  },
  {
      $sort: {'avg_reaction': -1}
  },
  {
      $project:{
          _id: 0,
          country: '$_id',
          avg_reaction: 1
      }
  }
])

//Вывести названия стримов без пожертвований или без реакций.
db.streams.aggregate([
{
    $lookup:{
        from:'donations',
        localField: 'id',
        foreignField: 'stream_id',
        as: 'donations'
    }
},

{
    $lookup:{
        from:'reactions',
        localField: 'id',
        foreignField: 'stream_id',
        as: 'reactions'
    }
},
//{    $unwind: '$reactions'},
//{    $unwind: '$donations'},
{
    $match:{
        $or:[
        {'streams.reactions': []},
        {'streams.donations': []}
        ]
    }
}
])

// Вывести максимальный размер пожертвования для каждого стримера
db.donations.aggregate([
   {
        '$lookup': {
            'from': 'streams',
            'localField': 'stream_id',
            'foreignField': 'id',
            'as': 'stream'
        }
    },
    {'$unwind': '$stream'},
    {
        '$group': {
            '_id': '$stream.user_id',
            'max_donation': {'$avg': '$amount'}
        }
    },
    {
        '$lookup': {
            'from': 'users',
            'localField': '_id',
            'foreignField': 'id',
            'as': 'streamer'
        }
    },
    {'$unwind': '$streamer'},
])

//Вывести ТОП-3 пожертвований из Германии (имя донатора и размер пожертвования).
db.donations.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "donator_id",
      foreignField: "id",
      as: "donator"
    }
  },
  {
      $unwind: '$donator'
  },
  {
    $match: {
      "donator.country": "Germany"
    }
  },
  {
    $sort: {
      amount: -1
    }
  },
  {
    $limit: 3
  },
  {
    $project: {
      _id: 0,
      "donator.fullname": 1,
      amount: 1
    }
  }
])

