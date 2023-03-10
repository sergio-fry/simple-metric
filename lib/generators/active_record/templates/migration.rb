class MetricCreate < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :metrics do |t|
      t.string :key
      t.text :data_set

      t.timestamps
    end

    add_index :metrics, :key, unique: true
  end
end
