db.getCollection("goods").find({})

//1) Вывести количественное распределение товаров по поставщикам, а также общую сумму поставленных товаров
db.goods.aggregate([
{$group:{
    _id: '$supplier_id',
    total_goods: {$count: {}},
    total_sum: {$sum:{$multiply:['$price', '$quantity']}}
}}
])
//(2) Вывести общую и среднюю продолжительность звонков по каждой теме
db.calls.aggregate([
{
    $unwind: {
        path: '$topic',
    preserveNullAndEmptyArrays: true}
},
{
    $group:{
        _id: '$topic',
        total_duration_secs:{$sum: '$duration_secs'},
        avg_duration_secs:{$avg: '$duration_secs'}
    }
}
])

//(3) Вывести тему звонков, по которой общались меньше всего
db.calls.aggregate([
{
    $unwind:{
        path: '$topic',
        preserveNullAndEmptyArrays: true
    }
},
{
    $group: {
        _id: '$topic',
    total_duration_secs:{$sum: '$duration_secs'}
}
},
{
    $sort:{'duration_secs': 1}
},
{
    $limit: 1
}
])

//(4) Вывести одного пользователя, с которым общались на тему кредита дольше всего
//поля: имя, продолжительность общения в часах
db.calls.aggregate([
{
    $match:{'topic': 'credit'}
    },
    {
        $group:{
            '_id': '$user_id',
            'total_duration_secs': {$sum: '$duration_secs'}
        }
    },
    {
        $sort:{'total_duration_secs': -1}
    },
    {
        $limit: 1
    },
    {
        $lookup:{
            'from':'users',
            'localField': '_id',
            'foreignField': 'id',
            as: 'user'
        }
    },
    {
        $unwind: {
            'path': '$user',
            'preserveNullAndEmptyArrays': true
        }
    },
    {
        '$project': {
            '_id': 0,
            'total_duration_hours': {'$divide': ['total_duration_secs', 3600]},
            'fullname': '$user.fullname'
        }
    }
])