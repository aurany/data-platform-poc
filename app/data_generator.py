
import time
import random
import uuid

from cassandra.cqlengine import columns
from cassandra.cqlengine import connection
from cassandra.cqlengine.management import sync_table, create_keyspace_simple
from cassandra.cqlengine.models import Model

from faker import Faker
import faker_commerce

fake = Faker()
fake.add_provider(faker_commerce.Provider)

# This is a simplified normalized model generally considered an anti-pattern
# when using Cassandra (recommended is "query-first").
class CustomerModel(Model):
    __keyspace__ = 'the_shop'
    __table_name__ = 'customers'
    __options__ = {'cdc': True}
    customer_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    customer_name = columns.Text()
    customer_address = columns.Text()

class ProductModel(Model):
    __keyspace__ = 'the_shop'
    __table_name__ = 'products'
    __options__ = {'cdc': True}
    product_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    product_name = columns.Text()
    product_price = columns.Float()

class OrderModel(Model):
    __keyspace__ = 'the_shop'
    __table_name__ = 'orders'
    __options__ = {'cdc': True}
    order_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    product_id = columns.UUID()
    customer_id = columns.UUID()
    order_quantity = columns.Integer()

def get_random_customer_id():
    customers = CustomerModel.objects.all() # should not fetch all in prod..
    customer_id = random.choice(customers).customer_id
    return customer_id

def get_random_product_id():
    products = ProductModel.objects.all() # should not fetch all in prod..
    product_id = random.choice(products).product_id
    return product_id


def generate_mock_data(num_customers, num_products, num_orders):

    [
        CustomerModel.create(
            customer_name=fake.name(),
            customer_address=fake.address()
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
            customer_id=get_random_customer_id(),
            order_quantity=random.choice([1, 2, 3, 4, 5])
        )
        for _ in range(num_orders)
    ]

def simulation():

    def _insert_customer():
        CustomerModel.create(
            customer_name=fake.name(),
            customer_address=fake.address()
        )

    def _update_customer():
        customer_id=get_random_customer_id()
        customer = CustomerModel.get(customer_id=customer_id)
        customer.customer_name=fake.name()
        customer.save()

    def _delete_customer():
        customer_id=get_random_customer_id()
        customer = CustomerModel.get(customer_id=customer_id)
        customer.delete()

    def _update_product():
        product_id=get_random_product_id()
        product = ProductModel.get(product_id=product_id)
        product.product_price=fake.ecommerce_price()
        product.save()

    def _insert_order():
        OrderModel.create(
            product_id=get_random_product_id(),
            customer_id=get_random_customer_id(),
            order_quantity=random.choice([1, 2, 3, 4, 5])
        )

    while True:
        random.choice([
            _insert_customer(),
            _update_customer(),
            _delete_customer(),
            _update_product(),
            _insert_order()
        ])
        time.sleep(1)

if __name__ == '__main__':
    
    # connect to database
    connection.setup(["cassandra"], "the_shop", protocol_version=3)
    create_keyspace_simple("the_shop", 1, durable_writes=True, connections=None)

    # create/sync tables
    [
        sync_table(model)
        for model in[CustomerModel, ProductModel, OrderModel]
    ]

    # truncate all data
    [
        connection.execute(f'TRUNCATE the_shop.{table}')
        for table in ['customers', 'products', 'orders']
    ]

    # generate mock data
    generate_mock_data(num_customers=1, num_products=1, num_orders=1)

    # start simulation
    simulation()