require "minitest/autorun"
require_relative "disc2.rb"

class PublicTests < Minitest::Test

    def test_chipotle_sales
    	assert_in_delta(5.0, chipotle_sales({2.5=>2}), 0.0001)
        assert_in_delta(0.0, chipotle_sales({}), 0.0001)
        assert_in_delta(4690.0, chipotle_sales({7.15=>400, 8.25=>200, 2.15=>50, 1.45=>50}), 0.0001)
    end

    def test_set
        set = Set.new()
        set.insert(1).insert(2).insert(3).insert(4).insert(5)
        
        sum = 0
        set.each do |x|
            sum += x
        end
        assert_equal(15, sum)
        
        set.remove(2).remove(4)
        set.each do |x|
            if x.even?
                flunk()
            end
        end

        set.clear()
        set.insert("Testudo").insert("Terrapin").insert("Terp")
        arr = []
        set.each do |x|
            arr << x
        end

        assert_equal(3, arr.length)
        assert(arr.include? "Testudo")
        assert(arr.include? "Terrapin")
        assert(arr.include? "Terp")
    end

    def test_is_decimal
        assert(is_decimal("+1.0"))
        assert(is_decimal("+1"))
        assert(is_decimal("-124.124"))
        assert(is_decimal("1"))
        assert(is_decimal("-1"))
        refute(is_decimal("1,000.0"))
        refute(is_decimal("1.1.1"))
    end

    def test_extract_student_data
        assert_equal({ :name => "Anwar Mamat", :id => "000000000" }, extract_student_data("name: Anwar Mamat, id: 000000000"))
        
        assert_equal(:error, extract_student_data("name: AnwarMamat, id: 000000000"))
        assert_equal(:error, extract_student_data("name: anwar mamat, id: 000000000"))
        assert_equal(:error, extract_student_data("name: anwar0 mamat, id: 000000000"))

        assert_equal(:error, extract_student_data("name: Anwar Mamat, id: 0000000000"))
        assert_equal(:error, extract_student_data("name: Anwar Mamat, id: 00000000"))
        assert_equal(:error, extract_student_data("name: Anwar Mamat, id: 00000000a"))

        assert_equal(:error, extract_student_data("name: Anwar Mamat,id: 000000000"))
        assert_equal(:error, extract_student_data("name: Anwar Mamat id: 000000000"))
        assert_equal(:error, extract_student_data("Name: Anwar Mamat, ID: 000000000"))
    end
end
