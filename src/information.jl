"""
# module information

- Julia version: 
- Author: Анастасия
- Date: 2019-11-27

# Examples

```jldoctest
julia>
```
"""
module information
    export user_instruction

function user_instruction()#данная функция разъясняет пользователю принцип работы с прошраммой, какие опции доступны, что они из себя представляют
    println("Ведение складского учета")
    println("Допустимые операции:")
    println("1. add - добавление товара на склад; ")
    println("2. delete - удаление товара со склада")
    println("3. total_price - общая стоимость всех товаров на складе")
    println("4. view_goods  - обзор всех товаров на складе")
    println("5. calc_cons - подсчет суммы требуемых к расходу товаров. По окончанию перечисления товаров введите end в графе 'наименование'")
    println("6. exit  - завершение работы")
    println("История всех производимых операций доступна в файле history")
    println(" ")
end
end