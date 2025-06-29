<?php

namespace App\Movies\Service;


use App\Movies\Entity\MovieInputDTO;
use App\Movies\Entity\MovieOutputDTO;

use App\Movies\Repository\MovieRepository;
use App\Movies\Entity\Movie;
use App\Movies\Mapper\MovieMapperFromDTO;
use App\Movies\Mapper\MovieMapperToDTO;

class MovieService
{
    private MovieRepository $movieRepository;
    private MovieMapperFromDTO $movieMapperFromDTO;
    private MovieMapperToDTO $movieMapperToDTO;

    public function __construct(MovieRepository $movieRepository, MovieMapperFromDTO $movieMapperFromDTO, MovieMapperToDTO $movieMapperToDTO)
    {
        $this->movieRepository = $movieRepository;
        $this->movieMapperFromDTO = $movieMapperFromDTO;
        $this->movieMapperToDTO = $movieMapperToDTO;
    }

    public function getMovieById(int $id): ?Movie
    {
        return $this->movieRepository->find($id);
    }

    public function getAllMovies(): array
    {
        return $this->movieRepository->findAll();
    }

    /**
     * Devuelve todas las películas activas.
     */
    public function getAllActiveMovies(): array
    {
        return $this->movieRepository->findBy(['status' => true]);
    }

    /**
     * Devuelve las más populares.
     */
    public function getTopPopularMovies(int $limit = 10): array
    {
        return $this->movieRepository->findMostPopular($limit);
    }

    /**
     * Buscar películas por título.
     */
    public function searchMovieByTitle(string $term): array
    {
        return $this->movieRepository->findByTitle($term);
    }
    /**
     * Guardar una película.
     */
    public function createMovieFromDto(MovieInputDTO $inputDto): MovieOutputDTO
    {
        // 1️⃣ Convertimos DTO a entidad
        $movie = $this->movieMapperFromDTO->fromDto($inputDto);

        // 2️⃣ Guardamos la película
        $this->movieRepository->save($movie, true);

        // 3️⃣ Convertimos entidad a DTO de salida
        return $this->movieMapperToDTO->toDto($movie);
    }

    /**
     * Eliminar una película por ID.
     */
    public function deleteMovieById(int $id): bool{
        $movie = $this->getMovieById($id);
        if(!$movie){
            return false;
        }
        $this->movieRepository->remove($movie, true);
        return true;

    }
}
