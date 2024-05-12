
from faker import Faker
import faker_commerce

import random
import uuid

from cassandra.cqlengine import columns
from cassandra.cqlengine import connection
from datetime import datetime
from cassandra.cqlengine.management import sync_table
from cassandra.cqlengine.models import Model

fake = Faker()
fake.add_provider(faker_commerce.Provider)

class UserModel(Model):
    user_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    user_name = columns.Text()
    user_address = columns.Text()

class ProductModel(Model):
    product_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    product_name = columns.Text()
    product_price = columns.Float()

class OrderModel(Model):
    order_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    product_id = columns.UUID()
    user_id = columns.UUID()


def get_random_user_id():
    users = UserModel.objects.all() # not in production..
    user_id = random.choice(users).user_id
    return user_id

def get_random_product_id():
    products = ProductModel.objects.all() # not in production..
    product_id = random.choice(products).product_id
    return product_id


def generate_mock_data(num_customers, num_products, num_orders):

    [
        UserModel.create(
            user_name=fake.name(),
            user_address=fake.address()
        )
        for _ in range(num_customers)
    ]

    [
        ProductModel.create(
            product_name=fake.ecommerce_name(),
            product_price=fake.ecommerce_price()
        )
        for _ in range(num_products)
    ]

    [
        OrderModel.create(
            product_id=get_random_product_id(),
            user_id=get_random_user_id()
        )
        for _ in range(num_orders)
    ]


if __name__ == '__main__':
    
    connection.setup(['127.0.0.1'], "the_shop", protocol_version=3)

    [
        sync_table(model)
        for model in[UserModel, ProductModel, OrderModel]
    ]

    generate_mock_data(num_customers=10, num_products=20, num_orders=40)

    # enable cdc per table?
