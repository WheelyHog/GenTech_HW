//(1) Напишите запрос, который создаст транзакцию (БД БАНК) с необходимыми полями.

db.transactions.insertOne(
   {
     transaction_id: 1,
     amount: 1000,
     date: new Date(),
     account: "123",
     status: "in progress"
   }
)

//(2) Приведите в качестве примера пять типовых бизнес-процессов, связанных с транзакциями, и соотвествующие им запросы в MongoDB.


//Поиск всех транзакций на определенную дату:
db.transactions.find(
{ 
date: { $eq: "2023-02-10" }
}
)

//Поиск всех транзакций, сумма которых превышает 1000
db.transactions.find(
{
amount: {$gte: 1000}
}
)

//Поиск транзакций по конкретному аккаунту
db.transactions.find({
account: {$eq: "123"}
})


//Поиск всех незавершенных транзакций
db.transactions.find({
status: {$eq: "in progress"}
})


//Удалить все транзакции до определенной даты
db.transactions.deleteMany({
date: {$lt: "01-01-1990"}
})