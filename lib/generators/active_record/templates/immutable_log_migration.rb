class CreateImmutableLog < ActiveRecord::Migration
  def change
    create_table :system_transactions, id: :uuid do |t|
      t.references :source, type: :uuid, polymorphic: true, index: { name: "transactions_on_source" }, null: false
      t.references :destination, type: :uuid, polymorphic: true, index: { name: "transactions_on_destination" }, null: false

      # Coin / currency is a dependent model
      t.references :source_coin, type: :uuid, foreign_key: { to_table: :coins }, index: true, null: false
      t.references :destination_coin, type: :uuid, foreign_key: { to_table: :coins }, index: true, null: false

      t.references :previous_transaction, type: :uuid, foreign_key: { to_table: :system_transactions }, index: true
      t.string :previous_transaction_hash

      t.references :initiated_by, type: :uuid, foreign_key: { to_table: :members }, index: true, null: false
      t.references :authorized_by, type: :uuid, foreign_key: { to_table: :members }, index: true

      t.string :type, null: false

      t.integer :source_quantity, limit: 8
      t.decimal :source_rate

      t.integer :destination_quantity, limit: 8
      t.decimal :destination_rate

      t.timestamps
    end

    create_table :events, id: :uuid do |t|
      t.string :type, null: false
      # Coin as currency -> dependent model
      t.references :coin, type: :uuid, foreign_key: true, index: true, null: false
      t.references :system_transaction, type: :uuid, foreign_key: true, index: true, null: false
      # User a dependent model, can we make this ommittable
      t.references :member, type: :uuid, foreign_key: true, index: true, null: false
      t.integer :entry, limit: 8, null: false
      t.decimal :rate

      t.timestamps
    end
  end
end
