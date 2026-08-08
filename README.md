# FURIMA

フリーマーケットアプリケーションです。

## ER図

```mermaid
erDiagram
  USERS ||--o{ ITEMS : sells
  USERS ||--o{ ORDERS : purchases
  ITEMS ||--o| ORDERS : has
  ORDERS ||--|| ADDRESSES : has

  USERS {
    bigint id PK
    string nickname
    string email UK
    string encrypted_password
    string last_name
    string first_name
    string last_name_kana
    string first_name_kana
    date birth_date
  }

  ITEMS {
    bigint id PK
    string name
    text description
    integer category_id
    integer condition_id
    integer shipping_fee_id
    integer prefecture_id
    integer shipping_day_id
    integer price
    bigint user_id FK
  }

  ORDERS {
    bigint id PK
    bigint user_id FK
    bigint item_id FK
  }

  ADDRESSES {
    bigint id PK
    string postal_code
    integer prefecture_id
    string city
    string house_number
    string building_name
    string phone_number
    bigint order_id FK
  }
```

## usersテーブル

| Column             | Type   | Options                   |
|--------------------|--------|---------------------------|
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| last_name          | string | null: false               |
| first_name         | string | null: false               |
| last_name_kana     | string | null: false               |
| first_name_kana    | string | null: false               |
| birth_date         | date   | null: false               |

### Association

- has_many :items
- has_many :orders

## itemsテーブル

| Column          | Type       | Options                        |
|-----------------|------------|--------------------------------|
| name            | string     | null: false                    |
| description     | text       | null: false                    |
| category_id     | integer    | null: false                    |
| condition_id    | integer    | null: false                    |
| shipping_fee_id | integer    | null: false                    |
| prefecture_id   | integer    | null: false                    |
| shipping_day_id | integer    | null: false                    |
| price           | integer    | null: false                    |
| user            | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :order

## ordersテーブル

| Column | Type       | Options                        |
|--------|------------|--------------------------------|
| user   | references | null: false, foreign_key: true |
| item   | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

## addressesテーブル

| Column        | Type       | Options                        |
|---------------|------------|--------------------------------|
| postal_code   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| house_number  | string     | null: false                    |
| building_name | string     |                                |
| phone_number  | string     | null: false                    |
| order         | references | null: false, foreign_key: true |

### Association

- belongs_to :order

## 設計方針

- 商品画像はActive Storageで管理するため、itemsテーブルには画像用カラムを設けません。
- カテゴリー、商品の状態、配送料の負担、発送元の地域、発送までの日数はActive Hashで管理します。
- 購入記録と配送先情報は責務が異なるため、ordersテーブルとaddressesテーブルに分離します。
- 建物名だけは入力任意とし、それ以外のユーザー入力項目は必須とします。
