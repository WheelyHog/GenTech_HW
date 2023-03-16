db.getCollection("users").find({})
//вывести размеры евро-транзакций из европы в долларах
db.transactions.aggregate([
{
    $lookup:{
        from: 'users',
        localField: 'sender_id',
        foreignField: 'id',
        as: 'sender'
    }
},
{
        $match:{
    'sender.is_europe': true,
    'currency': 'eur'
}
},
{
    $project: {
        'amount_usd': {$multiply: ['$amount', 1.05]}
    }
}
])


//вывести количество USD-транзакций из 'China'
db.transactions.aggregate([
{
    $lookup:{
        from: 'users',
        localField: 'sender_id',
        foreignField: 'id',
        as: 'sender'
    }
},
{
    $match: {
        'sender.country': 'China',
        'currency': 'usd'
    }
},
{
    $count: 'transactions_count'
}
])


//вывести три самых больших транзакции в 'usd'
db.transactions.aggregate([
{
    $match: {
        currency: 'usd'
    }
},
{
    $sort: {amount: -1}
},
{
    $limit: 3
}
])

//вывести всех незаблокированных пользователей, у которых есть завершенные (is_completed) транзакции от 10 usd
db.transactions.aggregate([
{
   $lookup: {
       from: 'users',
       localField: 'id',
       foreignField: 'id',
       as: 'user'
   }
},
{
    $match: {
        is_blocked: {$ne: true},
        is_completed: true,
        currency: 'usd',
        amount: {$gte: 10}
    }
}
])


//найти пользователей без транзакций
db.transactions.aggregate([
{
    $lookup: {
       from: 'users',
       localField: 'sender_id',
       foreignField: 'id',
       as: 'sender'
   }
},
{
    $lookup: {
       from: 'users',
       localField: 'recipient_id',
       foreignField: 'id',
       as: 'recipient'
   }
},
{
    $match:
    {$or: [{sender_id: []}, {recipient_id: []}]}
}
])