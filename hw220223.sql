-- Описание занятия: В рамках БД 'chat' с помощью SQL напишите запрос, который вывеадет информацию о чатах  (КТО С КЕМ ОБЩАЕТСЯ), отсортированных по дате посл/сообщения
use chat;

select messages.chat_id, users.fullname as user1, users.fullname as user2, messages.created_at
from users
join messages on users.user_id=messages.author_id
join messages on users.user_id=messages.recipient_id
group by messages.chat_id
order by messages.created_at desc