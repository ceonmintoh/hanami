# frozen_string_literal: true

RSpec.describe "Slices", :app_integration do
  it "Loading a slice uses a defined slice class" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/app.rb", <<~RUBY
        require "hanami"

        module TestApp
          class App < Hanami::App
          end
        end
      RUBY

      write "config/slices/main.rb", <<~RUBY
        module Main
          class Slice < Hanami::Slice
          end
        end
      RUBY

      write "slices/main/lib/foo.rb", <<~RUBY
        module Main
          class Foo; end
        end
      RUBY

      require "hanami/prepare"

      expect(Hanami.app.slices[:main]).to be Main::Slice
    end
  end

  it "Loading a slice with a defined slice class but no slice dir" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/app.rb", <<~RUBY
        require "hanami"

        module TestApp
          class App < Hanami::App
          end
        end
      RUBY

      write "config/slices/main.rb", <<~RUBY
        module Main
          class Slice < Hanami::Slice
          end
        end
      RUBY

      require "hanami/prepare"

      expect(Hanami.app.slices[:main]).to be Main::Slice
    end
  end

  it "Loading a slice generates a slice class if none is defined" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/app.rb", <<~RUBY
        require "hanami"

        module TestApp
          class App < Hanami::App
          end
        end
      RUBY

      write "slices/main/lib/foo.rb", <<~RUBY
        module Main
          class Foo; end
        end
      RUBY

      require "hanami/prepare"

      expect(Hanami.app.slices[:main]).to be Main::Slice
    end
  end

  it "Registering a slice with a block creates a slice class and evals the block" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/app.rb", <<~RUBY
        require "hanami"

        module TestApp
          class App < Hanami::App
            register_slice :main do
              register "greeting", "hello world"
            end
          end
        end
      RUBY

      require "hanami/prepare"

      expect(Hanami.app.slices[:main]).to be Main::Slice
      expect(Main::Slice["greeting"]).to eq "hello world"
    end
  end
end
