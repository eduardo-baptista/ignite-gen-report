defmodule GenReportTest do
  use ExUnit.Case

  alias GenReport
  alias GenReport.Support.ReportFixture

  @file_name "gen_report.csv"

  describe "build/1" do
    test "When passing file name return a report" do
      response = GenReport.build(@file_name)

      assert response == ReportFixture.build()
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build()

      assert response == {:error, "Insira o nome de um arquivo"}
    end
  end

  describe "build_from_many/1" do
    test "When passing a list of files it should return a valid report" do
      # Arrange
      file_names = [@file_name]

      # Act
      response = GenReport.build_from_many(file_names)

      # Assert
      assert response == ReportFixture.build()
    end

    test "When passing a invalid param it should return an error" do
      # Arrange
      invalid_param = 1234

      # Act
      response = GenReport.build_from_many(invalid_param)

      # Assert
      assert response == {:error, "Insira uma lista de arquivos valida"}
    end
  end
end
